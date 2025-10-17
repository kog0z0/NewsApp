
import { deviceInfo } from '@kit.BasicServicesKit';
import { window } from '@kit.ArkUI';
import Logger from './Logger';
import { CommonConstants } from '../common/CommonConstants';

@Observed
export class WindowUtil {
  private windowStage?: window.WindowStage;
  private mainWindowClass?: window.Window;

  static getInstance(): WindowUtil | undefined {
    if (!AppStorage.get<WindowUtil>(CommonConstants.WINDOW_UTIL)) {
      AppStorage.setOrCreate(CommonConstants.WINDOW_UTIL, new WindowUtil());
    } else {
      Logger.info(`AppStorage does not have windowUtil`);
    }
    return AppStorage.get<WindowUtil>(CommonConstants.WINDOW_UTIL);
  }

  setWindowStage(windowStage: window.WindowStage): void {
    this.windowStage = windowStage;
  }

  setMainWindowPortrait(): void {
    if (this.windowStage === undefined) {
      Logger.error(`WindowStage is undefined`);
      return;
    }
    this.windowStage.getMainWindow((err, windowClass: window.Window) => {
      this.mainWindowClass = windowClass;
      if (err.code) {
        Logger.error(`Failed to obtain the main window. Code:${err.code}, message:${err.message}`);
        return;
      }
      if (deviceInfo.deviceType !== CommonConstants.DEVICE_TYPES[0] && deviceInfo.deviceType !==
        CommonConstants.DEVICE_TYPES[1]) {
        this.mainWindowClass.setPreferredOrientation(window.Orientation.PORTRAIT);
      }
    });
  }

  setMainWindowOrientation(orientation: window.Orientation): void {
    if (this.mainWindowClass === undefined) {
      Logger.error(`MainWindowClass is undefined`);
      return;
    }
    this.mainWindowClass.setPreferredOrientation(orientation);
  }

  disableWindowSystemBar(): void {
    if (this.mainWindowClass === undefined) {
      Logger.error(`MainWindowClass is undefined`);
      return;
    }
    this.mainWindowClass.setWindowSystemBarEnable([]);
  }

  enableWindowSystemBar(): void {
    if (this.mainWindowClass === undefined) {
      Logger.error(`MainWindowClass is undefined`);
      return;
    }
    this.mainWindowClass.setWindowSystemBarEnable(['status', 'navigation']);
  }

  setFullScreen(): void {
    if (this.mainWindowClass === undefined) {
      Logger.error(`MainWindowClass is undefined`);
      return;
    }
    this.mainWindowClass.setWindowLayoutFullScreen(true);
  }

  getMainWindow(): window.Window | undefined {
    return this.mainWindowClass;
  }

  offWindowSizeChange(): void {
    if (this.mainWindowClass === undefined) {
      Logger.error(`MainWindowClass is undefined`);
      return;
    }
    this.mainWindowClass?.off('windowSizeChange');
  }
}