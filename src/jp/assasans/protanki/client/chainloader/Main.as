package jp.assasans.protanki.client.chainloader {
  import flash.display.Loader;
  import flash.display.LoaderInfo;
  import flash.display.NativeWindow;
  import flash.display.Screen;
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.system.ApplicationDomain;
  import flash.system.Capabilities;
  import flash.system.LoaderContext;
  import flash.system.Security;
  import flash.utils.ByteArray;

  public class Main extends Sprite {
    private var loader: Loader;
    private var game: *;

    public function Main() {
      super();

      addEventListener(Event.ADDED_TO_STAGE, this.init);
    }

    private function init(event: Event): void {
      removeEventListener(Event.ADDED_TO_STAGE, this.init);

      // TODO(Assasans): Flash Player prohibits the use local files with network support.
      try {
        Security.allowDomain('*');
      } catch(error) {
        // Throws SecurityError in AIR
      }

      const request: URLRequest = new URLRequest(loaderInfo.parameters['library']);
      const loader: URLLoader = new URLLoader();
      loader.dataFormat = 'binary';
      loader.addEventListener(Event.COMPLETE, this.byteArrayLoadComplete);
      loader.load(request);
    }

    private function byteArrayLoadComplete(event: Event): void {
      const bytes: ByteArray = (event.target as URLLoader).data as ByteArray;

      this.loader = new Loader();
      this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, this.onComplete);

      const serverEndpoint: Vector.<String> = Vector.<String>(loaderInfo.parameters['server'].split(':'));

      const parameters: Object = {
        lang: loaderInfo.parameters['locale'],
        ip: serverEndpoint[0],
        port: serverEndpoint[1],
        resources: loaderInfo.parameters['resources']
      };

      const context: LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
      context.parameters = parameters;
      context.allowCodeImport = true;

      this.loader.loadBytes(bytes, context);
    }

    private function onComplete(event: Event): void {
      this.loader.removeEventListener(Event.COMPLETE, this.onComplete);

      stage.stageFocusRect = false;
      stage.align = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;

      // Resize window if running in AIR
      const nativeWindow: NativeWindow = stage.nativeWindow;
      if(nativeWindow) {
        const bounds: Rectangle = nativeWindow.bounds;
        const screen: Screen = Screen.getScreensForRectangle(bounds)[0];

        stage.stageWidth = 1000;
        stage.stageHeight = 600;
        nativeWindow.minSize = new Point(nativeWindow.width, nativeWindow.height);
        nativeWindow.x = (screen.bounds.width - nativeWindow.width) / 2;
        nativeWindow.y = (screen.bounds.height - nativeWindow.height) / 2;
      }

      const loaderInfo: LoaderInfo = this.loader.contentLoaderInfo as LoaderInfo;

      const gameClass: Class = loaderInfo.applicationDomain.getDefinition('Game') as Class;
      this.game = new gameClass();

      const gameLoader: Sprite = new Sprite();
      const prelauncher: Sprite = new Sprite();

      // StandaloneLoader (this) -> Prelauncher -> Loader (gameLoader) -> Game
      addChild(prelauncher);
      prelauncher.addChild(gameLoader);
      gameLoader.addChild(game);

      // Pass execution to the game
      this.game.SUPER(stage, this, loaderInfo);

      if(nativeWindow) {
        nativeWindow.title = 'ProTanki [chainloaded]';
      }
    }
  }
}
