const createError = require('http-errors');
const prisma = require('../config/db');
const { defaultAddressSchema } = require('../config/joi');

module.exports = {
	getDefaultAddress: async (req, res, next) => {
		try {
			if (!req.payload.aud) {
				throw createError.Unauthorized();
			}
			const defaultAddress = await prisma.default_addresses.findMany({
				where: {
					customer_id: +req.payload.aud,
				},
				select: {
					default_address_id: true,
					customer_id: true,
					address_id: true,
				},
			});

			if (!defaultAddress)
				throw createError.NotFound('no default address found');

			res.json(defaultAddress);
		} catch (err) {
			console.log(err.message);
			next(err);
		}
	},
	setDefaultAddress: async (req, res, next) => {
		try {
			if (!req.payload.aud) {
				throw createError.Unauthorized();
			}
			const { address_id } = await defaultAddressSchema.validateAsync(req.body);

			const isfound = await prisma.default_addresses.findUnique({
				where: {
					customer_id: +req.payload.aud,
				},
			});

			if (isfound) throw createError.Conflict('default address already exists');

			const newDefaultAddress = await prisma.default_addresses.create({
				data: {
					customer_id: +req.payload.aud,
					address_id: +address_id,
				},
				select: {
					default_address_id: true,
					customer_id: true,
					address_id: true,
				},
			});

			res.json(newDefaultAddress);
		} catch (err) {
			console.log(err);
			if (err.name === 'ValidationError') {
				return next(createError(422, err.message));
			}
			next(err);
		}
	},
	updateDefaultAddress: async (req, res, next) => {
		try {
			if (!req?.payload?.aud) {
				throw createError.Unauthorized();
			}
			const { address_id } = await defaultAddressSchema.validateAsync(req.body);

			const isfound = await prisma.default_addresses.findUnique({
				where: {
					customer_id: +req.payload.aud,
				},
			});

			if (!isfound) {
				throw createError.NotFound(`no default address was found`);
			}

			const updatedAddress = await prisma.default_addresses.update({
				where: {
					customer_id: +req.payload.aud,
				},
				data: {
					address_id: address_id,
				},
				select: {
					default_address_id: true,
					customer_id: true,
					address_id: true,
				},
			});

			res.json(updatedAddress);
		} catch (err) {
			if (err.name === 'ValidationError') {
				return next(createError(422, err.message));
			}
			next(err);
		}
	},
	deleteDefaultAddress: async (req, res, next) => {
		try {
			if (!req?.payload?.aud) {
				throw createError.Unauthorized();
			}
			const isfound = await prisma.default_addresses.findUnique({
				where: {
					customer_id: +req.payload.aud,
				},
			});

			if (!isfound) {
				throw createError.NotFound(`default address not found`);
			}

			const deletedDefaultAddress = await prisma.default_addresses.delete({
				where: {
					customer_id: +req.payload.aud,
				},
			});

			res.json(deletedDefaultAddress);
		} catch (err) {
			console.log(err.message);
			next(err);
		}
	},
};
