const createError = require('http-errors');
const prisma = require('../config/db');
const { addressSchema, addressUpdateSchema } = require('../config/joi');

module.exports = {
	getAllUserAddresses: async (req, res, next) => {
		try {
			if (!req?.payload?.aud) {
				throw createError.Unauthorized();
			}
			const addresses = await prisma.addresses.findMany({
				where: {
					customer_id: +req.payload.aud,
				},
				select: {
					address_id: true,
					customer_id: true,
					first_name: true,
					last_name: true,
					mobile_phone_number: true,
					alternate_phone_number: true,
					delivery_address: true,
					county: true,
					town: true,
				},
			});
			if (!addresses) throw createError.NotFound('no addresses found');

			res.json(addresses);
		} catch (err) {
			console.log(err.message);
			next(err);
		}
	},
	getAddressById: async (req, res, next) => {
		try {
			if (!req?.payload?.aud) {
				throw createError.Unauthorized();
			}
			const { id } = req.params;

			const address = await prisma.addresses.findMany({
				where: {
					address_id: +id,
					customer_id: +req.payload.aud,
				},
				select: {
					address_id: true,
					customer_id: true,
					first_name: true,
					last_name: true,
					mobile_phone_number: true,
					alternate_phone_number: true,
					delivery_address: true,
					county: true,
					town: true,
				},
			});

			if (address.length === 0)
				throw createError.NotFound(`no address with id of ${id} was found`);

			res.json(address);
		} catch (err) {
			console.log(err.message);
			next(err);
		}
	},
	createAddress: async (req, res, next) => {
		try {
			if (!req?.payload?.aud) {
				throw createError.Unauthorized();
			}
			const {
				first_name,
				last_name,
				mobile_phone_number,
				alternate_phone_number,
				delivery_address,
				county,
				town,
			} = await addressSchema.validateAsync(req.body);

			const isfound = await prisma.addresses.findMany({
				where: {
					first_name: first_name,
					last_name: last_name,
					mobile_phone_number: mobile_phone_number,
					alternate_phone_number: alternate_phone_number,
					delivery_address: delivery_address,
					county: county,
					town: town,
					customer_id: +req.payload.aud,
				},
			});

			if (isfound.length > 0)
				throw createError.Conflict(`address already exists`);

			const newAddress = await prisma.addresses.create({
				data: {
					customer_id: +req.payload.aud,
					first_name: first_name,
					last_name: last_name,
					mobile_phone_number: mobile_phone_number,
					alternate_phone_number: alternate_phone_number,
					delivery_address: delivery_address,
					county: county,
					town: town,
				},
				select: {
					address_id: true,
					customer_id: true,
					first_name: true,
					last_name: true,
					mobile_phone_number: true,
					alternate_phone_number: true,
					delivery_address: true,
					county: true,
					town: true,
				},
			});

			if (!newAddress) {
				throw createError('could not save address');
			}

			const has_default_address = await prisma.default_addresses.findUnique({
				where: {
					customer_id: +req.payload.aud,
				},
			});

			if (!has_default_address) {
				const newDefaultAddress = await prisma.default_addresses.create({
					data: {
						customer_id: +req.payload.aud,
						address_id: newAddress.address_id,
					},
					select: {
						default_address_id: true,
						customer_id: true,
						addresses: {
							select: {
								address_id: true,
								customer_id: true,
								first_name: true,
								last_name: true,
								mobile_phone_number: true,
								alternate_phone_number: true,
								delivery_address: true,
								county: true,
								town: true,
							},
						},
					},
				});
				if (!newDefaultAddress)
					throw createError.InternalServerError(
						'could not set default address'
					);
			}

			res.json(newAddress);
		} catch (err) {
			console.log(err);
			if (err.name === 'ValidationError') {
				return next(createError(422, err.message));
			}
			next(err);
		}
	},

	updateAddressById: async (req, res, next) => {
		try {
			if (!req?.payload?.aud) {
				throw createError.Unauthorized();
			}

			const { id } = req.params;
			const request = await addressUpdateSchema.validateAsync(req.body);
			const userAddresses = await prisma.addresses.findMany({
				where: {
					customer_id: +req.payload.aud,
				},
			});
			const isfound = userAddresses.filter(
				({ address_id }) => address_id === +id
			);
			if (isfound.length === 0) {
				throw createError.NotFound(`no address with id of ${id} was found`);
			}
			const {
				first_name,
				last_name,
				mobile_phone_number,
				alternate_phone_number,
				delivery_address,
				county,
				town,
			} = isfound[0];

			const fullRequest = {
				first_name,
				last_name,
				mobile_phone_number,
				alternate_phone_number,
				delivery_address,
				county,
				town,
				...request,
			};
			console.log(fullRequest);
			const same = userAddresses.some(
				({
					first_name,
					last_name,
					mobile_phone_number,
					alternate_phone_number,
					delivery_address,
					county,
					town,
				}) => {
					const obj = {
						first_name,
						last_name,
						mobile_phone_number,
						alternate_phone_number,
						delivery_address,
						county,
						town,
					};
					if (objectsEqual(obj, fullRequest)) return true;
				}
			);
			if (same)
				throw createError.Conflict('an identical address already exists');

			const updatedAddress = await prisma.addresses.update({
				where: {
					address_id: +id,
				},
				data: request,
			});

			res.json(updatedAddress);
		} catch (err) {
			if (err.name === 'ValidationError') {
				return next(createError(422, err.message));
			}
			next(err);
		}
	},
	deleteAddressById: async (req, res, next) => {
		try {
			if (!req?.payload?.aud) {
				throw createError.Unauthorized();
			}
			const { id } = req.params;
			const userAddresses = await prisma.addresses.findMany({
				where: {
					customer_id: +req.payload.aud,
				},
			});

			const isfound = userAddresses.some(
				({ address_id }) => address_id === +id
			);

			if (!isfound) {
				throw createError.NotFound(`no address with id of ${id} was found`);
			}

			const deletedAddress = await prisma.addresses.delete({
				where: {
					address_id: +id,
				},
			});

			res.json(deletedAddress);
		} catch (err) {
			console.log(err.message);
			next(err);
		}
	},
};

function objectsEqual(o1, o2) {
	const entries1 = Object.entries(o1);
	const entries2 = Object.entries(o2);
	if (entries1.length !== entries2.length) {
		return false;
	}
	for (let i = 0; i < entries1.length; ++i) {
		// Keys
		if (entries1[i][0] !== entries2[i][0]) {
			return false;
		}
		// Values
		if (entries1[i][1] !== entries2[i][1]) {
			return false;
		}
	}

	return true;
}
