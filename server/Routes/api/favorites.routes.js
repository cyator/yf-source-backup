const express = require('express');
const router = express.Router();
const { verifyAccessToken } = require('../../config/jwt');

//controller
const {
	getFavorites,
	addToFavorites,
	deleteFromFavorites,
} = require('../../controller/favorites.controller');

// @method:get '/'
// @desc: fetch all favorites
// @access: private

router.get('/', verifyAccessToken, getFavorites);

// @method:post '/'
// @desc: add to favorites
// @access: private

router.post('/', verifyAccessToken, addToFavorites);

// @method:delete '/:id'
// @desc: remove product from Favorites
// @access: private

router.delete('/:id', verifyAccessToken, deleteFromFavorites);

module.exports = router;
