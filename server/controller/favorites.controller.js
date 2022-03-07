const createError = require('http-errors');
const prisma = require('../config/db');
const { favoriteSchema } = require('../config/joi');

module.exports = {
	getFavorites: async (req, res, next) => {
		try {
			if (!req?.payload?.aud) {
				throw createError.Unauthorized();
			}

			const favorites = await prisma.favorites.findMany({
				where: {
					customer_id: +req.payload.aud,
				},
				select: {
					favorite_id: true,
					product_id: true,
					products: {
						select: {
							product_name: true,
							price: true,
							price_type: true,
							category: true,
							stock: true,
							image: true,
						},
					},
				},
			});

			if (!favorites)
				throw createError.NotFound('you do not have any favorites');

			res.json(favorites);
		} catch (err) {
			console.log(err.message);
			next(err);
		}
	},

	addToFavorites: async (req, res, next) => {
		try {
			if (!req?.payload?.aud) {
				throw createError.Unauthorized();
			}

			const { product_id } = await favoriteSchema.validateAsync(req.body);

			const userFavorites = await prisma.favorites.findMany({
				where: {
					customer_id: +req.payload.aud,
				},
			});

			const isfound = userFavorites.some(
				(userFavorites) => userFavorites.product_id === +product_id
			);

			if (isfound)
				throw createError.Conflict(`product is already in favorites`);

			const newFavorite = await prisma.favorites.create({
				data: {
					customer_id: +req.payload.aud,
					product_id: +product_id,
				},
			});

			if (!newFavorite) {
				throw createError('could not save favorite');
			}

			res.json(newFavorite);
		} catch (err) {
			console.log(err);
			if (err.name === 'ValidationError') {
				return next(createError(422, err.message));
			}
			next(err);
		}
	},

	deleteFromFavorites: async (req, res, next) => {
		try {
			if (!req?.payload?.aud) {
				throw createError.Unauthorized();
			}
			const { id } = req.params;

			const userFavorites = await prisma.favorites.findMany({
				where: {
					customer_id: +req.payload.aud,
				},
			});

			const isfound = userFavorites.some(
				({ favorite_id }) => favorite_id === +id
			);

			if (!isfound) {
				throw createError.NotFound(`no favorite with id of ${id} was found`);
			}

			const deletedFavorite = await prisma.favorites.delete({
				where: {
					favorite_id: +id,
				},
			});

			res.json(deletedFavorite);
		} catch (err) {
			console.log(err.message);
			next(err);
		}
	},
};
