const { Router } = require('express');
const controller = require('../controllers/users.controller');
const { finishSession, logout } = require('../controllers/session.controller');
const { verifyAuthentication } = require('../controllers/session.controller');
const verifyValidation = require('../middleware/verify-validation');
const validate = require('../helpers/validate');

const router = Router();

router.route('/user')
	.post(
		controller.verifyUserRegistrationAuthorization,
		verifyValidation(validate.user.add),
		controller.addUser,
	)
	.all(verifyAuthentication)
	.get(controller.fetchUser)
	.put(
		verifyValidation(validate.user.update),
		controller.updateUser,
	)
	.delete(
		controller.removeAllUserTypes,
		finishSession,
		logout,
	);

router.put(
	'/user/new-password',
	verifyAuthentication,
	verifyValidation(validate.user.newPassword),
	controller.updatePassword,
);

router.route('/individual')
	.post(
		controller.verifyDealerRegistrationAuthorization({
			add: validate.individual.add,
			upgrade: validate.user.upgrade.individual,
		}),
		controller.addIndividual,
	)
	.all(
		verifyAuthentication,
		controller.verifyIndividualAuthorization,
	)
	.get(controller.fetchIndividual)
	.put(
		verifyValidation(validate.individual.update),
		controller.updateIndividual,
	)
	.delete(
		controller.removeIndividual,
		finishSession,
		logout,
	);

router.route('/garage')
	.post(
		controller.verifyDealerRegistrationAuthorization({
			add: validate.garage.add,
			upgrade: validate.user.upgrade.garage,
		}),
		controller.addGarage,
	)
	.all(
		verifyAuthentication,
		controller.verifyGarageAuthorization,
	)
	.get(controller.fetchGarage)
	.put(
		verifyValidation(validate.garage.update),
		controller.updateGarage,
	)
	.delete(
		controller.removeGarage,
		finishSession,
		logout,
	);

module.exports = router;
