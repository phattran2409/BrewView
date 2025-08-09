# Flutter Project Structure Guide (Human & AI Readable)

> Mục tiêu: Chuẩn hoá cấu trúc thư mục theo **feature-first MVVM** (Model - View - ViewModel), kết hợp **Repository/Service + DI (get\_it + injectable)** để con người và AI có thể đọc và tự động sinh code nhất quán.

---

## 0) Tóm tắt kiến trúc

* **Model**: Entity, DTO, mapper.
* **View**: UI hiển thị, nhận input.
* **ViewModel (Bloc/Cubit)**: Quản lý state, xử lý sự kiện, gọi Repository.
* **Repository**: Cầu nối ViewModel ↔ Service, quản lý nguồn dữ liệu.
* **Service**: Gọi API, đọc ghi DB, xử lý IO.
* **DI**: `get_it` + `injectable`.
* **Routing**: `go_router`.

---

## 1) Cấu trúc thư mục

```
lib/
├── app/
│   ├── app.dart                  # MaterialApp & GoRouter init
│   ├── di/                       # DI setup (locator.dart, locator.config.dart)
│   ├── router/                   # app_router.dart, route_paths.dart
│   └── theme/                    # Colors, typography
│
├── core/                         # Code dùng chung
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── utils/
│   └── widgets/
│
├── features/
│   └── <feature_name>/
│       ├── model/                # Entity, DTO, mapper
│       ├── view/                 # Pages, widgets
│       ├── viewmodel/            # Bloc/Cubit, state, event
│       ├── repository/           # Abstract + impl
│       └── services/             # API/local data sources
│
├── l10n/                         # Localization files
└── main.dart
```

> Mỗi feature đầy đủ MVVM và độc lập với feature khác.

---

## 2) Quy ước đặt tên

* **Model**: `<entity>.dart`, `<entity>_model.dart`
* **View**: `<name>_page.dart`, `<name>_widget.dart`
* **ViewModel (Bloc/Cubit)**: `<feature>_bloc.dart`, `<feature>_state.dart`, `<feature>_event.dart`
* **Repository**: `<feature>_repository.dart`, `<feature>_repository_impl.dart`
* **Service**: `<feature>_service.dart`

---

## 3) Luồng MVVM trong feature

```
View → ViewModel (Bloc/Cubit) → Repository → Service → API/DB
```

* **View**: gọi method trong ViewModel, render UI theo state.
* **ViewModel**: quản lý logic & state, không gọi IO trực tiếp.
* **Repository**: xử lý dữ liệu, gọi Service.
* **Service**: tương tác dữ liệu thô (API, DB, cache).

---

## 4) Ví dụ feature `user_management`

```
features/user_management/
├── model/
│   ├── user.dart
│   └── user_model.dart
├── view/
│   ├── user_list_page.dart
│   └── user_detail_page.dart
├── viewmodel/
│   ├── user_bloc.dart
│   ├── user_event.dart
│   └── user_state.dart
├── repository/
│   ├── user_repository.dart
│   └── user_repository_impl.dart
└── services/
    └── user_service.dart
```

---

## 5) DI và Routing

* **DI**: đăng ký Service, Repository, ViewModel trong `app/di` bằng annotation của `injectable`.
* **Routing**: định nghĩa trong `app/router` với `go_router`.

---

## 6) Checklist cho AI/Dev khi tạo feature mới

1. Tạo thư mục feature với 5 phần: model, view, viewmodel, repository, services.
2. Tạo model/entity & DTO.
3. Tạo service gọi API/DB.
4. Tạo repository (abstract + impl) sử dụng service.
5. Tạo viewmodel (Bloc/Cubit) gọi repository.
6. Tạo view hiển thị dữ liệu từ viewmodel.
7. Đăng ký DI.
8. Thêm route.
9. Viết test cơ bản.

---

## MACHINE\_README (AI-Oriented Spec)

```yaml
spec_version: 1.0.0
architecture: MVVM+BLoC
routing: go_router
state_management: bloc

directories:
  app:
    - di
    - router
    - theme
  core:
    - constants
    - errors
    - network
    - utils
    - widgets
  features:
    - "<feature_name>/model"
    - "<feature_name>/view"
    - "<feature_name>/viewmodel"
    - "<feature_name>/repository"
    - "<feature_name>/services"

naming:
  model: "<entity>.dart"
  dto: "<entity>_model.dart"
  page: "<name>_page.dart"
  widget: "<name>_widget.dart"
  bloc: "<feature>_bloc.dart"
  state: "<feature>_state.dart"
  event: "<feature>_event.dart"
  repo_abstract: "<feature>_repository.dart"
  repo_impl: "<feature>_repository_impl.dart"
  service: "<feature>_service.dart"

workflows:
  create_feature:
    steps:
      - "create model/entity & DTO"
      - "create service"
      - "create repository (abstract + impl)"
      - "create viewmodel (bloc/state/event)"
      - "create views (pages/widgets)"
      - "register DI annotations"
      - "add routes to app_router"
      - "run build_runner"

commands:
  di_generate: "flutter pub run build_runner build --delete-conflicting-outputs"
  di_watch: "flutter pub run build_runner watch --delete-conflicting-outputs"

rules:
  - "ViewModel/BLoC cannot call HTTP directly; must use repository"
  - "Service should not map to domain entities"
  - "Use MVVM layout in feature-first structure"
  - "No business logic inside Widgets"

quality_gates:
  - run: "flutter analyze"
  - run: "flutter test"

outputs_expected:
  - "New feature compiles without analyzer errors"
  - "At least 1 bloc test exists"
```
