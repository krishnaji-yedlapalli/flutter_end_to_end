// This file is for configuring commitlint, a tool that lints our commit messages.
// We use it to enforce the Conventional Commits standard, which is important for
// our automated release and versioning workflow.
// For more information, see: https://commitlint.js.org/

module.exports = {
  extends: ['@commitlint/config-conventional'],
};
