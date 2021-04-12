module.exports = {
  env: {
    es6: true,
    browser: true,
    node: true,
  },
  settings: {
    react: {
      // For Preact specific
      // pragma: "h",
      version: "detect",
    },
  },
  parser: "babel-eslint",
  parserOptions: {
    ecmaVersion: 2020,
    sourceType: "module",
    ecmaFeatures: {
      jsx: true,
    },
  },
  plugins: ["react", "react-hooks"],
  extends: [
    "eslint:recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended",
    "plugin:prettier/recommended",
  ],
  rules: {
    "no-else-return": "error",
    "no-lonely-if": "error",
    "no-self-compare": "error",
    "no-void": "error",

    // For Preact specific
    // "react/no-unknown-property": ["error", { ignore: ["class"] }],
    "react/prop-types": "off",

    "react/jsx-boolean-value": "error",
    "react/jsx-curly-brace-presence": "error",
    "react/self-closing-comp": "error",
    "react-hooks/exhaustive-deps": "error",
  },
};
