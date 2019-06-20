module.exports = {
  parser: 'babel-eslint',
  parserOptions: {
    ecmaVersion: 2017,
    sourceType: 'module',
    ecmaFeatures: { jsx: true },
  },
  plugins: [
    'react',
    'import',
  ],
  extends: [
    'eslint:recommended',
    "plugin:prettier/recommended",
    'plugin:react/recommended',
  ],
  rules: {
    "no-console": "off",
    "no-debugger": "off",
    "no-dupe-class-members": "off",
    "no-else-return": "error",
    "no-self-compare": "error",
    "no-void": "error",
    "no-var": "error",
    "no-lonely-if": "error",
    "prefer-const": "error",

    'import/order': 'error',

    'react/jsx-uses-vars': 'warn',
    'react/prop-types': 'off',
  },
  env: {
    browser: true,
    node: true,
    jest: true,
    es6: true
  },
};
