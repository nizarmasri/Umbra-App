module.exports = {
	root: true,
	env: {
		es6: true,
		node: true,
	},
	extends: ['eslint:recommended', 'google'],
	rules: {
		'require-jsdoc': 0,
		'quotes': ['error', 'single'],
		'indent': [2, 'tab'],
		'no-tabs': 0,
	},

	parserOptions: {
		ecmaVersion: 8,
	},
};
