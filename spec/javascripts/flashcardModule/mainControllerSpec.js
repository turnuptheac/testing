describe('MainCtrl', function() {
    beforeEach(module('flashcardApp'));

    var $controller;
    var $scope;
    var controller;
    var fakeFlashcards;

    beforeEach(inject(function(_$controller_){
        $controller = _$controller_;
        $scope = {};
        fakeFlashcards = {
            flashcards: [
                {
                    id: 1,
                    bin: 0,
                    question: "f",
                    answer: "g",
                    scheduled_time_to_revisit: null,
                    times_wrong: 0
                }
            ],
            create: sinon.spy()
        };
        controller = $controller('MainCtrl',{ $scope: $scope, flashcards: fakeFlashcards });
    }));


    it('sets scope flashcards', function() {
        expect($scope.flashcards).toEqual(fakeFlashcards.flashcards);
    });

    describe("$scope.addFlashcard", function() {
        describe("when flashcard values are unset", function() {
            it('does nothing', function() {
                $scope.addFlashcard();

                expect(fakeFlashcards.create.called).toBe(false);
            });
        });

        describe("when question is set", function() {
            beforeEach(function() {
                $scope.question = "utopia";
            });

            it('does nothing', function() {
                $scope.addFlashcard();

                expect(fakeFlashcards.create.called).toBe(false);
            });

            describe("when answer is set", function() {
                beforeEach(function() {
                    $scope.answer = "a non-existent place";
                });

                it("calls flashcard creation service", function() {
                    $scope.addFlashcard();

                    expect(fakeFlashcards.create).toHaveBeenCalledWith(
                        {
                            question: "utopia",
                            answer: "a non-existent place"
                        }
                    );
                })
            });
        });
    });
});