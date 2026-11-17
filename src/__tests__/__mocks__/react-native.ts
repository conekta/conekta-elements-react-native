import { vi } from 'vitest';

// A native view is a host element named after it: the component under test returns that element as it is.
export const requireNativeComponent = vi.fn((viewName: string) => viewName);
