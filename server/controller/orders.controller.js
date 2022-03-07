const createError = require('http-errors');
const { orderSchema } = require('../config/joi');
const prisma = require('../config/db');

module.exports = {
	getAllOrders: async (req, res, next) => {
		try {
			if (!req?.payload?.aud) {
				throw createError.Unauthorized();
			}

			const orders = await prisma.orders.findMany({
				where: {
					customer_id: +req.payload.aud,
				},
			});
			if (!orders) throw createError.NotFound('no orders found');

			res.json(orders);
		} catch (err) {
			console.log(err.message);
			next(err);
		}
	},
	getOrderById: async (req, res, next) => {
		try {
			if (!req?.payload?.aud) {
				throw createError.Unauthorized();
			}

			const { id } = req.params;
			const order = await prisma.orders.findUnique({
				where: {
					order_id: +id,
					customer_id: +req.payload.aud,
				},
			});
			if (!order)
				throw createError.NotFound(`no order with id of ${id} was found`);

			res.json(order);
		} catch (err) {
			console.log(err.message);
			next(err);
		}
	},
	createOrder: async (req, res, next) => {
		try {
			if (!req?.payload?.aud) {
				throw createError.Unauthorized();
			}

			const { CheckoutRequestID, cart, amount, shipping } =
				await orderSchema.validateAsync(req.body);

			const paid = await prisma.stk.findUnique({
				where: {
					checkoutrequestid: CheckoutRequestID,
				},
			});
			console.log(paid);
			if (!paid) throw createError.BadRequest('invalid CheckoutRequestID');

			const newOrder = await prisma.orders.create({
				data: {
					payment_id: +paid.payment_id,
					customer_id: +req.payload.aud,
					amount_payable: +amount,
					shipping_cost: +shipping,
				},
			});

			if (!newOrder) {
				throw createError('could not save order');
			}

			cart.map(async ({ product_id, quantity }) => {
				const newCartItem = await prisma.cart.create({
					data: {
						order_id: newOrder.order_id,
						product_id: product_id,
						quantity: quantity,
					},
				});
				if (!newCartItem) {
					throw createError('could not save cart item');
				}
			});

			const savedOrder = await prisma.orders.findUnique({
				where: {
					order_id: newOrder.order_id,
				},
				include: {
					cart: true,
				},
			});

			res.json(savedOrder);
		} catch (err) {
			console.log(err);
			if (err.name === 'ValidationError') {
				return next(createError(422, err.message));
			}
			next(err);
		}
	},
};
