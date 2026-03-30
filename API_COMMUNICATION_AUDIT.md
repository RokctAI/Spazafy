# Data and API Communication Audit Summary - Flutter (Mobile)

## 1. Flutter (Mobile) Slices

### Data/Models
- **Request Models**: 
    - **Location**: `lib/infrastructure/models/request/`
    - **Naming Convention**: File names use `snake_case` (e.g., `sign_up_request.dart`), and classes use `PascalCase` (e.g., `SignUpRequest`).
    - **Example**: `lib/infrastructure/models/request/edit_profile.dart`
- **Response Models**: 
    - **Location**: `lib/infrastructure/models/response/`
    - **Naming Convention**: File names use `snake_case` (e.g., `login_response.dart`), and classes use `PascalCase` (e.g., `LoginResponse`).
    - **Example**: `lib/infrastructure/models/response/payments_response.dart`
- **Shared Data Entities**:
    - **Location**: `lib/infrastructure/models/data/` (e.g., `user.dart`, `shop_data.dart`)

### Repositories
- **Location**: `lib/infrastructure/repositories/` (and subdirectories like `manager/` and `driver/` for specific app roles).
- **API Call Logic**: 
    - Concrete repository classes implement interfaces defined in the `domain` layer.
    - They use **Dio** for HTTP communication, typically initializing a client via a global helper like `dioHttp.client(requireAuth: true/false)`.
    - Methods handle the full request cycle: constructing the endpoint URL, passing data/query parameters, and catching exceptions.
- **Interaction with Models**:
    - **Requests**: Data is passed to the API either as raw parameters or by converting a Request Model to a Map using `.toJson()`.
    - **Responses**: Upon a successful response, the JSON data is parsed into a Response Model using the `.fromJson()` factory constructor.
    - **Return Pattern**: Repositories return a `Future<ApiResult<T>>`, a functional wrapper that represents either a `success` state (with the model) or a `failure` state (with error details).

### Serialization
- **Pattern**: The project predominantly uses **manual serialization**.
- **Implementation**:
    - **Factory Constructors**: `fromJson(dynamic json)` is manually implemented to map map keys to class properties.
    - **To JSON**: `toJson()` methods are manually implemented to return a `Map<String, dynamic>`.
- **Note on Build Tools**: Although `freezed` and `json_serializable` are listed in `pubspec.yaml`, they are primarily used for application state or newer data structures, while core infrastructure models remain manually serialized.
