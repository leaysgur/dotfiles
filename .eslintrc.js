module.exports = {
  parser: 'babel-eslint',
  env: {
    browser: true,
    node: true,
    es6: true
  },
  parserOptions: {
    ecmaVersion: 2017,
    sourceType: 'module',
    ecmaFeatures: {
      jsx: true,
    },
  },
  plugins: [
    'react', 'flowtype'
  ],
  extends: [
    'eslint:recommended',
    'plugin:react/recommended',
    'plugin:flowtype/recommended'
  ],
  rules: {
    'strict': [2, 'global'],

    'default-case': 2,
    'no-self-compare': 2,
    'no-else-return': 2,
    'no-throw-literal': 2,
    'no-console': 0,
    'no-debugger': 0,
    'no-void': 2,
    'no-var': 2,
    'no-new-require': 2,
    'no-lonely-if': 2,
    'no-nested-ternary': 2,
    'no-multiple-empty-lines': [2, { 'max': 2 }],
    'no-unused-vars': [2, {'args': 'all', 'argsIgnorePattern': '^_'}],
    'no-unused-expressions': 0,
    'no-use-before-define': 0,
    'semi': [2, 'always'],
    'quotes': [2, 'single'],

    'react/jsx-uses-vars': 1
  }
};
