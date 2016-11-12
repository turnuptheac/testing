
angular.module('flashcardApp', ['ui.router'])
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
            answer: $scope.answer,
        });
        $scope.question = '';
        $scope.answer = '';
    };
    $scope.test = 'Boom!';
}]);


angular.module('flashcardApp')
.factory('flashcards', [
    '$http',
    function($http){
        var o = {
            flashcards: []
        };

        o.getAll = function() {
            return $http.get('/flashcards.json').
                success(function(data){
                    angular.copy(data, o.flashcards);
                });
        };

        o.create = function(flashcard) {
            return $http.post('/flashcards.json', flashcard)
                .success(function(data){
                    o.flashcards.push(data);
                });
        };

        return o;
    }
])

