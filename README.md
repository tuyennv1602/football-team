# myfootball

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.io/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.io/docs/cookbook)

For help getting started with Flutter, view our 
[online documentation](https://flutter.io/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

Tôi biết rồi ông ơi, cái provider đó thực ra là network provider vốn nằm tở tầng network layer, nên nếu như bài của ông kko truy xuất dữ liệu từ nguồn internet như API thì vứt cái đó đi và chỉ dùng repo thôi, kiểu lấy dữ liệu đổ vào model thì repo sẽ làm luôn. Còn nếu cần đến API thì lúc này thằng provider sẽ đóng vai trò là chuẩn bị dữ liệu, còn repo thì là nơi truy xuất dữ liệu, thằng bloc muốn lấy dữ liệu chỉ có thể thông qua thằng repo mà thôi, nó đảm bảo tính bao đóng là bảo vệ an toàn dữ liệu. Má thể mấy cái này làm quen tay thôi chứ mà hỏi về lý thuyết thì khối người ko nói đc, demo thì đc trình bảy theo cách hiểu của tác giả.
