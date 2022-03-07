const createError = require('http-errors');
const {
	signAccessToken,
	signRefreshToken,
	verifyRefreshToken,
} = require('../config/jwt');
const bcrypt = require('bcryptjs');
const prisma = require('../config/db');
const client = require('../config/redis');
//validation
const { loginSchema, registerSchema } = require('../config/joi');
const { NotFound } = require('http-errors');

module.exports = {
	register: async (req, res, next) => {
		try {
			const { username, email, password } = await registerSchema.validateAsync(
				req.body
			);

			const isfound = await prisma.customers.findUnique({
				where: {
					email: email,
				},
			});

			if (isfound) throw createError.Conflict(`${email} is already registered`);

			const hashedPassword = await bcrypt.hash(password, 14);

			const newCustomer = await prisma.customers.create({
				data: {
					username: username,
					email: email,
					password: hashedPassword,
				},
			});

			if (newCustomer) {
				const accessToken = await signAccessToken(newCustomer.customer_id);
				const refreshToken = await signRefreshToken(newCustomer.customer_id);

				res.cookie('refreshToken', refreshToken, {
					secure: process.env.NODE_ENV === 'development' ? false : true,
					httpOnly: true,
					sameSite: true,
				});
				res.json(accessToken);
			} else {
				throw createError.InternalServerError('error registering user');
			}
		} catch (err) {
			if (err.isJoi === true) err.status = 422;
			next(err);
		}
	},
	login: async (req, res, next) => {
		try {
			//validate request
			const { email, password } = await loginSchema.validateAsync(req.body);

			const customer = await prisma.customers.findUnique({
				where: {
					email: email,
				},
			});

			if (!customer) {
				throw createError.Unauthorized(
					'Invalid Email and Password Combination'
				);
			}
			//compare passwords
			const isMatch = await bcrypt.compare(password, customer.password);

			if (!isMatch)
				throw createError.Unauthorized(
					'Invalid Email and Password Combination'
				);

			const accessToken = await signAccessToken(customer.customer_id);
			const refreshToken = await signRefreshToken(customer.customer_id);

			res.cookie('refreshToken', refreshToken, {
				httpOnly: true,
				sameSite: true,
				secure: process.env.NODE_ENV === 'development' ? false : true,
			});
			res.json(accessToken);
		} catch (error) {
			console.log(error.message);
			if (error.isJoi === true)
				return next(
					createError.BadRequest('Invalid Email and Password Combination')
				);
			next(error);
		}
	},
	refreshToken: async (req, res, next) => {
		try {
			// const { refreshToken } = req.body;
			const { refreshToken } = req.cookies;
			if (!refreshToken) throw createError.BadRequest();
			const userId = await verifyRefreshToken(refreshToken);
			const newAccessToken = await signAccessToken(userId);
			const newRefreshToken = await signRefreshToken(userId);

			res.cookie('refreshToken', newRefreshToken, {
				secure: process.env.NODE_ENV === 'development' ? false : true,
				httpOnly: true,
				sameSite: true,
			});
			res.json(newAccessToken);
		} catch (err) {
			next(err);
		}
	},
	logout: async (req, res, next) => {
		try {
			const { refreshToken } = req.cookies;
			if (!refreshToken) throw createError.BadRequest();
			const userId = await verifyRefreshToken(refreshToken);
			client.DEL(userId, (err, value) => {
				if (err) {
					console.log(err.message);
					throw createError.InternalServerError(
						'an error occured while trying to logout'
					);
				}
				res.clearCookie('refreshToken');
				res.sendStatus(204);
			});
		} catch (err) {
			next(err);
		}
	},
	getUser: async (req, res, next) => {
		try {
			if (!req?.payload?.aud) {
				throw createError.Unauthorized();
			}
			const customer = await prisma.customers.findUnique({
				where: {
					customer_id: +req.payload.aud,
				},
				select: {
					username: true,
					email: true,
				},
			});

			if (!customer) {
				throw (createError, NotFound('user not found'));
			}
			res.json(customer);
		} catch (error) {
			console.log(error.message);
			next(error);
		}
	},
};
