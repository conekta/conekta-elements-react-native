import { vi } from 'vitest';
import React from 'react';

export const requireNativeComponent = vi.fn((viewName: string) =>
  React.forwardRef((props: Record<string, unknown>, ref: unknown) =>
    React.createElement(viewName, { ...props, ref })
  )
);
