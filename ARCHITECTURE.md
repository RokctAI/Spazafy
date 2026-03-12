# Spazafy — Technical Architecture Document
**Rokct Holdings · February 2026 · v1.6**

---

## 0. Comparison: Implementation vs Architectural Vision

> [!TIP]
> **⭐ Choice** indicates the path that is architecturally superior for Spazafy's long-term scale.

| Category | What we did (Device) | What Doc Suggests (Device) | What we want to do (Backend) | What Doc Suggests (Backend) | Choice / Superiority | Status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Database** | Hive / Ad-hoc JSON | **Drift (SQLite)** | Postgres (Standard) | Postgres + **pgvector** | **Drift + pgvector** ⭐ | [ ] |
| **Sync Layer** | Direct REST calls | **Sync Queue Service** | Standard Frappe API | **Idempotent REST** | **Sync Queue + Idempotency** ⭐ | [ ] |
| **ID Logic** | Int / Auto-increment | **Universal Strings** | Int (Standard) | **String ID Support** | **String-based IDs** ⭐ | [ ] |
| **Margins** | Mapping in Notifiers | **Device-side WAC** | Server-side Mapping | **Audit / Log only** | **On-Device WAC** ⭐ | [ ] |
| **AI / Patterns** | Simple logs | **rcore Event Queue** | Activity Log | **Brain Engram Builder** | **rcore -> Brain** ⭐ | [ ] |

---

## Sections
1. Platform Overview
2. Infrastructure
3. Backend Stack
4. Flutter Apps
5. Offline-First Architecture
6. Product & SKU Model
7. AI & Intelligence Layer
8. Ordering & Fulfilment
9. Payments
10. Data Flows
11. Event Logger — rcore (Shared Component)
12. IoT & Drone Extension
13. Build & Deployment
14. Open Technical Decisions

---

## 1. Platform Overview

Spazafy is a B2B spaza restocking platform. It delivers wholesale stock to spaza shops on a next-day basis, eliminating the need for owners to leave their shops to buy stock. The platform consists of a multi-tenant Frappe backend, a suite of Flutter mobile apps, and an on-device offline-first POS that syncs to the cloud on connectivity.

Spazafy operates as one tenant within a larger multi-tenant infrastructure (Rokct Holdings) built on a customised Frappe bench with ERPNext, Payments, Brain, rcore, paas, and Control apps installed across control and tenant sites.

### Platform Modes

> **DECISION** — Two flavours ship from one codebase via GitHub Actions: Spazafy Marketplace (B2C, existing) and Spazafy B2B (spaza POS + stock management). A compile-time feature flag activates the relevant mode. Code4Mzansi demo uses B2B mode.

---

## 2. Infrastructure

### 2.1 rPanel

Proprietary VPS management panel built by Rokct Holdings — equivalent to FastPanel but fully controlled. Manages server provisioning, site creation, SSL, process management, and monitoring across the stack. No dependency on third-party hosting panels.

### 2.2 Multi-Tenant Architecture

One control site orchestrates many tenant sites. Each tenant is an isolated Frappe site with its own database. Spazafy B2B runs as a dedicated tenant site—this app uses this one tenant site as its primary backend. All Flutter apps point to this tenant.

```
control.rokct.app           → Control site (orchestration, provisioning)
spazafy.rokct.app           → Spazafy B2B tenant site
  ├── frappe                core framework
  ├── erpnext               ERP — purchasing, inventory, suppliers
  ├── payments              payment gateway integrations
  ├── rcore                 shared utilities, present on all sites
  ├── brain                 AI layer — engrams, embeddings, sentence transformers
  └── paas                  delivery platform — orders, routes, fulfilment
```

### 2.3 Database

PostgreSQL with the pgvector extension enabled. pgvector is used across Brain and paas for semantic and behavioural vector storage and similarity search.

| App | Uses pgvector | Primary purpose |
|---|---|---|
| brain | Yes | Engram embeddings, sentence transformer outputs |
| paas | Yes | Product embeddings, demand vectors, shop profiles |
| erpnext | No | Standard relational — purchasing, inventory, accounts |
| rcore | No | Shared utilities, base doctypes |
| payments | No | Payment records and gateway state |

---

## 3. Backend Stack

### 3.1 Frappe Framework v15

Core framework. Provides REST API, authentication, doctypes, background jobs (RQ), email, file management, and the activity log that Brain consumes. All backend apps are Frappe apps.

### 3.2 ERPNext

Full ERP installed on the Spazafy tenant. Relevant modules:

- **Purchasing** — purchase orders to wholesalers, supplier management, landed costs
- **Stock / Inventory** — warehouses, stock entries, batch tracking, item master
- **Accounts** — supplier invoices, payment reconciliation, cost of goods

> **NOTE** — Spazafy does not rebuild procurement or stock valuation. It extends ERPNext's existing models. A spaza shop order becomes a Sales Order in ERPNext. The wholesaler pickup becomes a Purchase Order. Stock movement on delivery is a Stock Entry.

### 3.3 Brain

The AI and intelligence layer. Brain serves all other apps on the tenant.

- **Sentence Transformers** — embedding generation for semantic search and product matching. Model hosted inside Brain, called via internal API from paas and other apps.
- **pgvector management** — Brain owns the vector store schema and index management. Other apps write and query vectors through Brain's API, not directly.
- **Engram Builder** — consumes Frappe activity logs and the mobile event queue to build structured memory units (engrams) per entity — shop, owner, product, drone, sensor.
- **Recommendation Engine** — work in progress. Surfaces reorder suggestions, demand forecasts, and anomaly alerts based on engram state.

#### Engram Model

An engram is a structured record built from repeated patterns in activity data. Not a raw log entry — a compressed, meaningful representation of behaviour.

```json
{
  "shop_id": "SHOP-001",
  "product_sku": "SKU-CHAPPIES-LOOSE",
  "pattern": "low_stock_dismissed_repeatedly",
  "observations": 4,
  "last_seen": "2026-02-24",
  "suggested_action": "increase_threshold_or_auto_add_to_cart",
  "confidence": 0.87
}
```

### 3.4 paas

The delivery platform app. Owns order management, route planning, wholesaler routing logic, fulfilment tracking, and the mobile event queue receiver. Calls Brain for AI capabilities rather than implementing them directly.

### 3.5 rcore

Installed on every site. Contains shared doctypes, utility functions, and base configurations that all other apps depend on. Acts as the common foundation layer.

The **Event Logger** (Section 11) lives here — making it available to every app on every tenant automatically.

### 3.6 Payments

Frappe Payments app. Handles payment gateway integrations. Shop2Shop QR payment flow will be integrated here.

---

## 4. Flutter Apps

### 4.1 App Overview

| App | User | Form factor | Primary function |
|---|---|---|---|
| POS (spazafy_pos) | Spaza owner | Sunmi T-series tablet | Selling, stock, reorder — full feature set |
| Manager (spazafy_manager) | Spaza owner | Phone | Same as POS, phone layout — Code4Mzansi demo device |
| Driver (spazafy_driver) | Shopper/delivery | Phone | Wholesaler pickup list, delivery manifest, route |
| Customer (spazafy_customer) | End customer | Phone | Marketplace ordering, WhatsApp integration — B2C flavour |

> **NOTE** — POS and Manager share the same core codebase with different layout breakpoints. Manager app is used for Code4Mzansi demo because it is phone-sized and easier to demonstrate live.

### 4.2 Build Flavours

GitHub Actions builds two flavours from one codebase. The feature flag is set at compile time via Dart defines.

```bash
flutter build apk --dart-define=FLAVOUR=b2b
flutter build apk --dart-define=FLAVOUR=marketplace
```

```dart
const flavour = String.fromEnvironment('FLAVOUR', defaultValue: 'marketplace');
final isB2B = flavour == 'b2b';
```

The B2B flavour activates: local-first mode, POS flow, inventory management, reorder intelligence, event queue logging, and Brain sync. The marketplace flavour activates: customer ordering, WhatsApp shopping integration, and existing delivery tracking.

### 4.3 Current State

All apps currently use Frappe REST API directly with PostgreSQL as the only data store. Local storage does not exist yet. Migration to offline-first (Drift) is the primary technical work required before Code4Mzansi.

> **DECISION** — Manager app is the priority for local-first migration. POS tablet follows the same pattern once Manager is stable.

---

## 5. Offline-First Architecture

### 5.1 The Problem

Township connectivity is unreliable. The current architecture (Flutter → Frappe API → PostgreSQL) fails silently when offline. The entire app must function without any network connection. The backend is the sync target, not the source of truth during operation.

### 5.2 Local Database — Drift (SQLite)

> **DECISION** — Drift over Isar. Rationale: data model is relational (products, packs, child SKUs, stock movements, orders, suppliers). Team already thinks in SQL from PostgreSQL. Schema translation from Frappe doctypes to Drift tables is straightforward. Hive is key-value based and unsuitable for the complex relational lookups required for Spazafy.

#### Core Tables — Phase 1 (minimum for demo)

```sql
-- products
id, barcode, name, category, is_pack, units_per_pack,
parent_barcode, selling_price, cost_price, has_expiry,
photo_path, embedding_blob, last_updated

-- stock
id, product_id, quantity, supplier, cost_at_purchase,
received_date, expiry_date, order_ref

-- sales
id, product_id, quantity, selling_price, cost_price_at_sale,
timestamp, synced

-- event_queue  (see Section 11)
id, source, event_type, entity_id, payload_json, timestamp, synced

-- sync_queue
id, entity_type, entity_id, operation, payload_json,
created_at, synced_at, status
```

#### Phase 2 Tables

- `orders` — pending and confirmed stock orders
- `order_items` — line items per order
- `suppliers` — wholesalers and informal suppliers
- `price_list` — current cost prices per product, versioned
- `reorder_preferences` — per-product thresholds and preferred quantities

### 5.3 Data Flow

```
// Before (current)
Flutter UI  →  Frappe REST API  →  PostgreSQL

// After (target)
Flutter UI  →  Drift (local)  →  Sync Service  →  Frappe API  →  PostgreSQL
                                              ↘  Brain API   →  Engram Store
```

### 5.4 Sync Service

A background isolate in Flutter that runs independently of the UI.

- **Outbound — transactions** — flush sync_queue to Frappe on connectivity. Retry with exponential backoff on failure. Use local-timestamp IDs as idempotency keys.
- **Outbound — events** — flush event_queue directly to Brain. Separate from transaction sync.
- **Inbound — price list** — check version on connection. Pull YAML/XML diff if server version is newer.
- **Inbound — catalogue** — pull new or updated products. Changed records only.
- **Inbound — images** — pull changed product photos by filename hash. Never the full library.
- **Inbound — order confirmations** — pull confirmed orders and auto-populate stock. Owner never scans platform-sourced stock.

### 5.5 Conflict Resolution

| Conflict type | Resolution |
|---|---|
| Local sale vs server stock count | Local wins — device is source of truth for transactions |
| Product name / image from catalogue | Server wins — Spazafy catalogue is canonical |
| Owner selling price | Local always wins — never overwritten |
| Cost price from price list | Server wins — Spazafy sets cost prices |
| Owner-created product vs catalogue match | Prompt owner once, then server wins on confirmation |

### 5.6 Initial Device Provisioning

Devices are pre-loaded before shipping. Full product catalogue, reference photo library, and initial price list installed at warehouse. Owner turns on the device and Spazafy is fully functional immediately. No large downloads in the field.

### 5.7 Peer-to-Peer (Mesh) Sync [FUTURE]

To further minimize data costs, Spazafy can implement a "Mesh" sync pattern:
1. **Driver-to-POS**: When a driver arrives, the Driver app can push the delivery manifest directly to the POS via **Local Bluetooth/Wi-Fi Hotspot**.
2. **Impact**: Confirms delivery and populates stock locally without either device needing a cloud connection at that exact moment.
3. **Reconciliation**: Both devices sync their combined state to the cloud whenever they next hit a stable 4G/Fibre connection.

---

## 6. Product & SKU Model

### 6.1 Barcode Is the Truth

Every product is identified by its barcode. The central catalogue is the canonical source. When device data and catalogue data conflict on identity, the catalogue wins (with one owner confirmation for owner-created products).

### 6.2 Pack / Child SKU Hierarchy

A product can be a single item or a pack. Packs have a defined unit count in the catalogue. The pack barcode links to a child SKU. No confirmation from the owner is needed on receiving.

```
Parent (pack of 100):
  barcode:        6001234500001
  name:           Chappies 100-pack
  is_pack:        true
  units_per_pack: 100

Child SKU (auto-created):
  barcode:        6001234500001-UNIT
  name:           Chappie (single)
  parent_barcode: 6001234500001
  selling_price:  [set by owner]

// Scanning the 100-pack on receiving adds 100 child units to stock.
// Selling one Chappie deducts 1 child unit.
```

### 6.3 Stock Valuation — Weighted Average Cost

> **DECISION** — Weighted average cost (WAC). Rationale: same product may arrive at different cost prices from different suppliers. WAC gives a single always-current margin figure without accounting complexity.

```
new_wac = (existing_qty × existing_wac + new_qty × new_cost)
          / (existing_qty + new_qty)
```

Depletion follows FIFO — oldest stock sold first. Expiry-tracked products additionally surface soonest-expiring stock first within FIFO.

### 6.4 Owner-Added Products

If an owner receives stock not in the catalogue, they snap a photo. The on-device vision model classifies it (see Section 7.1). If no confident match exists, owner names it and sets a selling price. Cost price is optional. The product lives locally and is flagged to Spazafy team on next sync for central catalogue addition.

### 6.5 Selling Price vs Cost Price

| Field | Set by | Updated by | Pushed from server |
|---|---|---|---|
| selling_price | Owner | Owner only | Never |
| cost_price (Spazafy product) | Spazafy | Weekly price sync | Yes — YAML/XML diff |
| cost_price (other supplier) | Owner (optional) | Owner only | Never |

---

## 7. AI & Intelligence Layer

### 7.1 On-Device Vision — Photo Classification

**Model** — MobileCLIP or MoonDream (quantized ONNX). Runs entirely on device. No internet required. Selected for ability to run on Sunmi T-series hardware within acceptable inference time (<2 seconds).

**Reference Library** — product embeddings pre-computed centrally and stored as float arrays. Pushed to devices as part of weekly sync — only changed entries.

```
1. Owner snaps photo of unknown item
2. Quantized model generates embedding vector (on device)
3. Cosine similarity computed in Dart against all reference embeddings
4. Top match returned if confidence > threshold
5. Owner confirms or rejects
6. If rejected, owner names product manually
7. Unknown product flagged in event_queue for central catalogue review
```

**Embedding Storage** — reference embeddings stored as BLOB in Drift `products.embedding_blob`. Cosine similarity computed in Dart. Viable for up to ~1000 products on device.

### 7.2 Backend Vector Intelligence — Brain + pgvector

All server-side AI runs through Brain. paas calls Brain via internal API and does not interact with pgvector directly.

- **Sentence transformers** — semantic product search and matching
- **Shop profile vectors** — each shop represented as an embedding built from ordering behaviour. Used for similarity-based recommendations.
- **Demand forecasting** — vector similarity across historical demand patterns
- **Anomaly detection** — shop behaviour vector has shifted from its own baseline

```
POST /api/method/brain.api.get_reorder_suggestions
{
  "shop_id": "SHOP-001",
  "context": "low_stock_prompt",
  "top_k": 5
}
```

### 7.3 The Engram System

#### Input Sources

- **Frappe activity log** — native document changes, submissions, views. Already consumed by Brain.
- **Mobile event queue** — behavioural events from Flutter apps via rcore Event Logger (Section 11).
- **IoT event queue** — telemetry and state events from drones and sensors via same rcore Event Logger (Section 12).

Brain's engram builder is **source-agnostic**. It receives the event envelope, routes to the engram builder, and interprets meaning from the payload regardless of whether the source was a human finger tap or a drone sensor.

---

## 8. Ordering & Fulfilment

### 8.1 Order Cycle

```
Owner adds to cart  →  cart intent visible to server immediately
                    →  consolidation decisions made before cutoff
Owner confirms order before daily cutoff
                    →  order locked for tomorrow's run
Spazafy places purchase orders with wholesalers (ERPNext PO)
Shopper picks up consolidated list per wholesaler
Shopper delivers to each shop
                    →  delivery confirmed on Driver app
                    →  stock auto-populates on owner device (no scan required)
```

### 8.2 Multi-Wholesaler Routing

The system routes each product to the cheapest available wholesaler. The owner sees one price and one delivery. Routing decisions are made server-side by paas, invisible to the owner.

#### Cart as Demand Signal

Cart additions are sent to the server in real time. This gives Spazafy visibility into pre-order intent before orders are confirmed, enabling route planning before cutoff.

#### Consolidation Logic

```
For each product in pending carts across area:

  if already_visiting_wholesaler this cycle:
    → absorb, minor margin adjustment

  else if total_order_value >= min_trip_threshold:
    → schedule wholesaler pickup

  else:
    → show bundle nudge to relevant owners
    → if accepted: trip justified, order proceeds
    → if declined: substitute from closer wholesaler or absorb into next cycle
```

#### Bundle Nudge

A quantity increase offer shown before checkout when a wholesaler trip is not yet justified. The saving is real — it reflects genuine logistics efficiency. A decline for the same product three times is logged as an event and the nudge is suppressed permanently for that product/owner combination.

### 8.3 Shopper App — Driver View

One consolidated pick list per wholesaler for the day — total quantities, not broken down by shop. After purchase confirmed, system generates per-shop delivery manifests. On delivery confirmation, backend fires stock updates to each owner's device.

### 8.4 Pricing Consistency

One cost price per product per week across all shops. Weekly price sync pushes a versioned price list. All routing and margin decisions are made behind this fixed price.

---

## 9. Payments

### 9.1 Shop2Shop QR

Primary payment method for unbanked spaza owners. The owner already has a Shop2Shop wallet through their Flash airtime device. No bank account, no card, no new behaviour required.

```
Order confirmed on Spazafy POS
  → Spazafy generates merchant QR code for order total
  → Owner opens Shop2Shop app on Flash device
  → Owner scans Spazafy QR
  → Payment deducted from owner's Shop2Shop wallet
  → Spazafy merchant account receives payment
  → Order status updated to paid → released to fulfilment
  → Spazafy withdraws to bank account as needed
```

> **NOTE** — Flash does not provide API access to small players. The QR flow bypasses this entirely — it uses Shop2Shop's existing consumer payment capability, not a merchant API. The owner's Flash device stays unchanged.

### 9.2 Future Payment Methods

- Cash on delivery — driver collects, records on Driver app
- Credit (stock now, pay after selling) — enabled by trading history credit profile, underwritten by Brain behavioural data

---

## 10. Data Flows

### 10.1 What Lives Where

| Data | Primary store | Syncs to | Frequency |
|---|---|---|---|
| Sales transactions | Drift (device) | Frappe / ERPNext | On connectivity |
| Stock movements | Drift (device) | Frappe / ERPNext | On connectivity |
| Owner events | Drift event_queue | Brain directly | On connectivity |
| IoT events | rcore event_queue | Brain directly | On connectivity |
| Product catalogue | Frappe + Drift | Device ← server | Weekly + on demand |
| Product photos | Device filesystem | Device ← server | On change only |
| Reference embeddings | Drift BLOB | Device ← Brain | Weekly + on change |
| Price list | Frappe + Drift | Device ← server | Weekly |
| Orders | Frappe (ERPNext) | Device ← server | On confirmation |
| Engrams | Brain + pgvector | Brain only | Built continuously |
| Shop profile vectors | Brain + pgvector | Brain only | Updated on sync |

### 10.2 Compliance Data Exhaust

Every sale, stock movement, and supplier interaction logged through Spazafy constitutes a formal trading record. These aggregate into anonymised shop profiles on the backend. The DSBD-facing dashboard reads from aggregate profiles — not individual shop data. The owner never explicitly files anything. Compliance is a byproduct of using the tool.

---

## 11. Event Logger — rcore (Shared Component)

### 11.1 Why rcore

The event logger is a generic, reusable component. It does not care whether the source is a finger tap on a phone or a telemetry reading from a drone. Because it lives in rcore it is available to every app on every tenant automatically — Spazafy POS, IoT apps, anything built on the platform in future.

### 11.2 Event Envelope

All events share the same envelope regardless of source. The payload is the event's business — the envelope is always identical.

```json
{
  "source": "mobile_pos",
  "event_type": "low_stock_dismissed",
  "entity_id": "SHOP-001",
  "entity_type": "shop",
  "payload": {
    "product_sku": "SKU-CHAPPIES-LOOSE",
    "stock_qty": 4,
    "threshold": 5
  },
  "timestamp": "2026-02-26T09:14:00Z",
  "session_id": "uuid"
}
```

### 11.3 Local Storage — Drift

The event_queue table lives in Drift on the client device (or in a local queue on an IoT device). The structure is identical regardless of source.

```sql
event_queue:
  id, source, event_type, entity_id, entity_type,
  payload_json, timestamp, synced, synced_at
```

### 11.4 Sync to Brain

The event queue flushes directly to Brain's endpoint — not through Frappe's document pipeline. This is intentional: Brain processes raw behavioural signals, not structured business documents. Keeping them separate means Brain's API is stable regardless of ERPNext schema changes.

```dart
// On connectivity — two parallel sync operations
SyncService.run() async {
  await transactionSync.flush();  // → Frappe API → PostgreSQL
  await eventQueueSync.flush();   // → Brain API  → Engram store
}
```

### 11.5 Spaza POS Events

| Event | Trigger | Brain value |
|---|---|---|
| sale_completed | Item sold | Velocity and rhythm |
| low_stock_shown | Threshold breached | Baseline — warning surfaced |
| low_stock_dismissed | Owner dismisses | Pattern — owner ignores |
| low_stock_acted | Owner opens reorder cart | Positive engagement |
| bundle_offer_shown | Quantity nudge displayed | Baseline |
| bundle_offer_accepted | Owner increases quantity | Price sensitivity |
| bundle_offer_declined | Owner keeps qty | Buying behaviour |
| bundle_offer_declined_3x | Third consecutive decline | Stop asking — log preference |
| order_confirmed | Order placed | Reorder frequency and basket |
| stock_received | Delivery confirmed | Lead time and supplier preference |
| product_added_manual | Unknown product added | Catalogue gap signal |

---

## 12. IoT & Drone Extension

### 12.1 Overview

The rcore Event Logger was designed generically from the start. Adding drone or sensor telemetry to Brain requires no changes to the event logger architecture — only a new source type and relevant event definitions.

Brain builds engrams from patterns. Whether that pattern is a spaza owner dismissing a low stock warning or a drone consistently reporting low battery at a specific GPS coordinate, the mechanism is identical.

### 12.2 Event Examples — Drone

```json
{
  "source": "iot_drone",
  "event_type": "battery_low",
  "entity_id": "DRONE-007",
  "entity_type": "drone",
  "payload": {
    "battery_pct": 18,
    "location_lat": -26.2041,
    "location_lng": 28.0473,
    "altitude_m": 42,
    "mission_id": "DELIVERY-RUN-042"
  },
  "timestamp": "2026-02-26T11:30:00Z",
  "session_id": "uuid"
}
```

### 12.3 Potential Drone Event Types

| Event | Trigger | Brain value |
|---|---|---|
| mission_started | Drone dispatched | Baseline for mission tracking |
| waypoint_reached | Checkpoint hit | Route compliance and timing |
| battery_low | Below threshold | Pattern — where does battery drain fastest |
| battery_critical | Emergency level | Anomaly — unplanned drain |
| delivery_confirmed | Package dropped | Successful fulfilment |
| delivery_failed | Could not deliver | Pattern — which locations fail |
| geofence_breach | Left permitted zone | Safety and compliance signal |
| obstacle_detected | Collision avoidance triggered | Route hazard mapping |
| signal_lost | Connectivity dropped | Dead zone mapping |
| signal_restored | Connectivity returned | Dead zone boundary |
| landing_forced | Emergency land | Anomaly — investigate cause |
| maintenance_due | Flight hour threshold | Predictive maintenance signal |

### 12.4 What Brain Can Build From Drone Engrams

- **Route intelligence** — which paths have consistent signal loss, obstacle events, or battery drain anomalies
- **Predictive maintenance** — drone behaviour patterns that precede failures
- **Delivery failure prediction** — locations or times that correlate with failed deliveries
- **Fleet optimisation** — which drones perform best on which route profiles

---

## 13. Build & Deployment

### 13.1 GitHub Actions — Flutter

Two flavours built automatically from main branch on tagged releases.

```yaml
# Simplified workflow matrix
strategy:
  matrix:
    flavour: [b2b, marketplace]
    build_type: [debug, release]

steps:
  - flutter build apk
      --dart-define=FLAVOUR=${{ matrix.flavour }}
      --${{ matrix.build_type }}
```

### 13.2 Frappe / Backend

Deployed and managed via rPanel and customised bench. Tenant sites provisioned by Control app. The Spazafy tenant is provisioned with paas and its dependencies.

---

## 14. Open Technical Decisions

### Priority — Required Before Demo

- **Drift schema** — design and implement core tables: products, stock, sales, event_queue, sync_queue. Unblocks everything else.
- **Sync service** — build outbound transaction sync and event queue sync as separate background isolates.
- **On-device embedding** — benchmark MobileCLIP vs MoonDream on target Sunmi hardware. Implement cosine similarity in Dart.
- **Manager app local-first** — migrate all UI reads and writes from Frappe API calls to Drift. API calls move exclusively to sync service.
- **Brain event endpoint** — build the Brain API endpoint that receives mobile event payloads and routes to engram builder.

### Required Soon After

- **Sunmi T-series model** — confirm correct model in hospitality line (no payment license). Test app launcher mode.
- **Shop2Shop QR payment** — confirm merchant QR flow works for stock order payments. Integrate with Frappe Payments.
- **Price list sync format** — decide YAML vs XML for diffs. Implement version checking and incremental apply.
- **pgvector use case audit** — document what pgvector is currently powering in paas. Confirm which queries need to be preserved or re-architected for B2B model.
- **Minimum order threshold** — validate against real township order sizes before hardcoding.

### Strategic — Later

- **ERPNext purchasing integration** — map Spazafy B2B orders to ERPNext Purchase Orders. Map delivery confirmation to Stock Entries.
- **Credit scoring model** — define how trading history translates to stock credit eligibility. Brain engrams as input to underwriting logic.
- **DSBD compliance dashboard** — anonymised aggregate view for government reporting. Define data sharing terms and consent model.
- **Catalogue crowdsourcing** — build workflow for owner-submitted unknown products to flow through to central catalogue review and publication.
- **IoT event definitions** — define drone and sensor event types and payload schemas for Brain ingestion. No architecture changes required — event logger is already generic.

---

*Spazafy — Technical Architecture — Rokct Holdings — February 2026*
