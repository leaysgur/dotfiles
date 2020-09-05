module.exports = {
  parserOptions: {
    ecmaVersion: 2020,
    sourceType: 'module',
  },
  plugins: [],
  extends: [
    'eslint:recommended',
    "plugin:prettier/recommended",
  ],
  rules: {
    "no-else-return": "error",
    "no-lonely-if": "error",
    "no-self-compare": "error",
    "no-void": "error",
  },
  env: {
    browser: true,
    es6: true,
    node: true,
  },
};

