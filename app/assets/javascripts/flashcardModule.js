angular.module('flashcardApp', ['ui.router', 'angularMoment'])
.config([
'$stateProvider',
'$urlRouterProvider',
function($stateProvider, $urlRouterProvider) {
    $stateProvider
        .state('home', {
            url: '/home',
            templateUrl: '/home.html',
            controller: 'MainCtrl',
            resolve: {
                flashcardsPromise: ['flashcards', function(flashcards){
                    return flashcards.getAll();
                }]
            }
        })
        .state('review', {
            url: '/review',
            templateUrl: '/review.html',
            controller: 'ReviewCtrl',
            resolve: {
                flashcardsPromise: ['flashcards', function(flashcards){
                    return flashcards.getNextCardToReview();
                }]
            }
        });

  $urlRouterProvider.otherwise('home');
}])

angular.module('flashcardApp')
.controller('MainCtrl', [
'$scope',
'flashcards',
function($scope, flashcards) {
    $scope.flashcards = flashcards.flashcards;

    $scope.addFlashcard = function() {
        if(!$scope.question || $scope.question === '') { return; }
        if(!$scope.answer || $scope.answer === '') { return; }
        flashcards.create({
            question: $scope.question,
            answer: $scope.answer
        });
        $scope.question = '';
        $scope.answer = '';
    };
}]);

angular.module('flashcardApp')
.controller('ReviewCtrl', [
'$scope',
'flashcards',
function($scope, flashcards) {
    $scope.readyToReview = false;
    $scope.nextCardToReview = function() { return flashcards.nextCardToReview; }

    $scope.markCorrect = function() {
        $scope.readyToReview = false;
        flashcards.markCorrect($scope.nextCardToReview());
    };

    $scope.markIncorrect = function() {
        $scope.readyToReview = false;
        flashcards.markIncorrect($scope.nextCardToReview());
    };
}]);

angular.module('flashcardApp')
.factory('flashcards', [
    '$http',
    function($http){
        var o = {
            flashcards: [],
            nextCardToReview: null
        };

        o.getAll = function() {
            return $http.get('/flashcards.json').
                success(function(data) {
                    angular.copy(data, o.flashcards);
                });
        };

        o.create = function(flashcard) {
            return $http.post('/flashcards.json', flashcard)
                .success(function(data) {
                    o.flashcards.push(data);
                });
        };

        o.getNextCardToReview = function() {
            return $http.get('/flashcards/next_card_to_review.json')
                .success(function(data) {
                    o.nextCardToReview = data;
                });
        }

        o.markCorrect = function(flashcard) {
            return $http.post('/flashcards/' + flashcard.id + '/mark_correct')
                .then(function(data) {
                    o.getNextCardToReview();
                });
        }

        o.markIncorrect = function(flashcard) {
            return $http.post('/flashcards/' + flashcard.id + '/mark_incorrect')
                .then(function(data) {
                    o.getNextCardToReview();
                });
        }

        return o;
    }
])

