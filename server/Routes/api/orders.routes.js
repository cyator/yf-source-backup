const express = require('express');
const router = express.Router();
const { verifyAccessToken } = require('../../config/jwt');

//controller
const {
	getAllOrders,
	getOrderById,
	createOrder,
} = require('../../controller/orders.controller');

// @method:get '/'
// @desc: fetch all orders for user
// @access: private

router.get('/', verifyAccessToken, getAllOrders);

// @method:get '/:id'
// @desc: fetch order by id
// @access: private

router.get('/:id', verifyAccessToken, getOrderById);

// @method:post '/'
// @desc: create order
// @access: private

router.post('/', verifyAccessToken, createOrder);

module.exports = router;
