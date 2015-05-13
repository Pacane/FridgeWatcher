part of fridge_watcher;

@Component(selector: 'my-app', injectables: const [Engine])
@View(templateUrl: 'packages/fridge_watcher/components/my-app.html')
class AppComponent {
  Engine engine;

  AppComponent(this.engine) {
    name = engine.allo;
  }

  String name;

  void test() {
    print("how!");
  }
}
