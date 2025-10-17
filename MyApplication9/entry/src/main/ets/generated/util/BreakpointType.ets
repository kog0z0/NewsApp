
import { BreakpointConstants } from "../common/BreakpointConstants";

export class BreakpointType<T> {
  sm: T;
  md: T;
  lg: T;

  constructor(sm: T, md: T, lg: T) {
    this.sm = sm;
    this.md = md;
    this.lg = lg;
  }

  getValue(currentWidthBreakpoint: string): T {
    if (currentWidthBreakpoint === BreakpointConstants.BREAKPOINT_MD) {
      return this.md;
    }
    if (currentWidthBreakpoint === BreakpointConstants.BREAKPOINT_LG) {
      return this.lg;
    } else {
      return this.sm;
    }
  }
}