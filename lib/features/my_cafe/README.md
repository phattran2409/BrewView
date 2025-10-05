# My Cafe Feature

This feature provides complete CRUD (Create, Read, Update, Delete) operations for cafe management, following the established MVVM + BLoC architecture pattern.

## Features Implemented

### 1. Models
- `CafeModel` - Main cafe entity with JSON serialization
- `CreateCafeRequest` - Request model for creating new cafes
- `UpdateCafeRequest` - Request model for updating existing cafes
- `CategoryModel` - Category entity for cafe categorization
- `FeatureTagModel` - Feature tags for cafe characteristics

### 2. Services
- `MyCafeService` - Handles all API calls for cafe operations
  - Get all cafes for current user
  - Get cafe by ID
  - Create new cafe with media upload
  - Update existing cafe
  - Delete cafe
  - Get categories and feature tags

### 3. Repository Layer
- `MyCafeRepository` - Abstract repository interface
- `MyCafeRepositoryImpl` - Concrete implementation with DI registration

### 4. ViewModel (BLoC)
- `MyCafeBloc` - State management for cafe operations
- `MyCafeEvent` - Events for all cafe operations
- `MyCafeState` - States for different UI scenarios

### 5. Views
- `MyCafesListPage` - List view showing all user's cafes
- `MyCafeDetailPage` - Detail view with edit/delete functionality
- `MyCafeFormPage` - Unified form for create and edit operations
- `CafeCardWidget` - Reusable cafe card component
- `MyCafeNavigationButton` - Demo navigation button

### 6. Navigation
- Added routes to `app_router.dart`:
  - `/my-cafes` - List page
  - `/my-cafes/:id` - Detail page
  - `/my-cafes/create` - Create form
  - `/my-cafes/:id/edit` - Edit form

### 7. Demo Integration
- Added "My Cafes" demo button to login page
- Follows the same pattern as existing demo buttons

## API Endpoints Expected

The service expects these backend endpoints:
- `GET /api/cafes/owner/{userId}` - Get user's cafes
- `GET /api/cafes/{id}` - Get cafe by ID
- `POST /api/cafes` - Create new cafe (multipart/form-data)
- `PUT /api/cafes/{id}` - Update cafe (multipart/form-data)
- `DELETE /api/cafes/{id}` - Delete cafe
- `GET /api/categories` - Get all categories
- `GET /api/feature-tags` - Get all feature tags

## Form Features

The create/edit form includes:
- Image picker with multiple image support
- Category selection dropdown
- Feature tags multi-selection
- All required cafe fields (name, address, description, price range, hours, etc.)
- Form validation
- Loading states

## UI/UX Features

- Consistent with existing app design (coffee brown theme)
- Responsive layout
- Error handling with user-friendly messages
- Loading states
- Confirmation dialogs for delete operations
- Pull-to-refresh functionality
- Empty states with helpful messaging

## Architecture Compliance

- Follows MVVM + BLoC pattern
- Uses dependency injection with `@injectable`
- Implements repository pattern for data abstraction
- Proper separation of concerns
- Consistent with existing codebase patterns
