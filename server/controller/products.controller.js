const createError = require('http-errors');
const prisma = require('../config/db');
const { productSchema, productUpdateSchema } = require('../config/joi');
const fs = require('fs');
const path = require('path');

module.exports = {
	getAllProducts: async (req, res, next) => {
		try {
			const products = await prisma.products.findMany({});
			if (!products) {
				throw createError.NotFound('no products found');
			}
			res.json(products);
		} catch (err) {
			console.log(err.message);
			next(err);
		}
	},
	getProductsById: async (req, res, next) => {
		try {
			const { id } = req.params;
			const product = await prisma.products.findUnique({
				where: {
					product_id: +id,
				},
			});
			if (!product) {
				throw createError.NotFound(`no product with id of ${id} was found`);
			}
			res.json(product);
		} catch (err) {
			console.log(err.message);
			next(err);
		}
	},
	createProduct: async (req, res, next) => {
		try {
			const { product_name, price, price_type, category, stock } =
				await productSchema.validateAsync(req.body);
			if (req.file == undefined) {
				throw createError.BadRequest('No file selected');
			}
			const filename = req.file.filename;

			const isfound = await prisma.products.findUnique({
				where: {
					product_name: product_name,
				},
			});
			if (isfound)
				throw createError.Conflict(`${product_name} is already in store`);

			const newProduct = await prisma.products.create({
				data: {
					product_name,
					price,
					price_type,
					category,
					stock,
					image: filename,
				},
			});

			if (!newProduct) {
				throw createError('could not save product');
			}

			res.json(newProduct);
		} catch (err) {
			console.log(err);
			if (err.name === 'ValidationError') {
				return next(createError(422, err.message));
			}
			next(err);
		}
	},

	updateProductById: async (req, res, next) => {
		try {
			const { id } = req.params;
			let request = await productUpdateSchema.validateAsync(req.body);

			const filename = req.file?.filename;

			if (filename) {
				request = { ...request, filename };
			}

			const isfound = await prisma.products.findUnique({
				where: {
					product_id: +id,
				},
			});

			if (!isfound)
				throw createError.NotFound(`no product with id of ${id} was found`);

			const updatedProduct = await prisma.products.update({
				where: {
					product_id: +id,
				},
				data: request,
			});

			res.json(updatedProduct);
		} catch (err) {
			if (err.name === 'ValidationError') {
				return next(createError(422, err.message));
			}
			next(err);
		}
	},
	deleteProductById: async (req, res, next) => {
		try {
			const { id } = req.params;

			const isfound = await prisma.products.findUnique({
				where: {
					product_id: +id,
				},
			});

			if (!isfound) {
				throw createError.NotFound(`no product with id of ${id} was found`);
			}

			if (isfound.image) {
				fs.unlinkSync(path.join(__dirname, '..', 'uploads', isfound.image));
			}

			const deletedProduct = await prisma.products.delete({
				where: {
					product_id: +id,
				},
			});

			res.json(deletedProduct);
		} catch (err) {
			console.log(err.message);
			next(err);
		}
	},
};
