describe AssignmentQuestionnaire do
    let(:answer1) {Answer.new(id: 1, question_id: 1, response_id: 3) }
    let(:answer2) {Answer.new(id: 2, question_id: 4, response_id: 5) }
  
    before(:each) do
        @assignment1 = double('Assignment', id: 1)
        allow(Assignment).to receive(:find).with('1').and_return(@assignment1)
        @questionnaire1 = double('Questionnaire', id: 1)
        allow(Questionnaire).to receive(:find).with('1').and_return(@questionnaire1)
        @questionnaire2 = double('Questionnaire', id: 2)
        allow(Questionnaire).to receive(:find).with('2').and_return(@questionnaire2)
        @duedate1 = double('Duedate', id: 1, due_at: '2019-11-30 23:30:12', deadline_type_id: 1, parent_id: 1, round: 1)
        allow(DueDate).to receive(:find).with('1').and_return(@duedate1)
        @duedate2 = double('Duedate', id: 2, due_at: '2500-12-30 23:30:12', deadline_type_id: 2, parent_id: 1, round: 1)
        allow(DueDate).to receive(:find).with('2').and_return(@duedate2)
        @duedate3 = double('Duedate', id: 3, due_at: '2019-01-30 23:30:12', deadline_type_id: 1, parent_id: 1, round: 2)
        allow(DueDate).to receive(:find).with('3').and_return(@duedate3)
        @duedate4 = double('Duedate', id: 4, due_at: '2019-02-28 23:30:12', deadline_type_id: 2, parent_id: 1, round: 2)
        allow(DueDate).to receive(:find).with('4').and_return(@duedate4)
        @assignment_questionnaire1 = double('AssignmentQuestionnaire', id: 1, assignment_id: 1, questionnaire_id: 1, used_in_round: 1)
        allow(AssignmentQuestionnaire).to receive(:find).with('1').and_return(@assignment_questionnaire1)
        @assignment_questionnaire2 = double('AssignmentQuestionnaire', id: 2, assignment_id: 1, questionnaire_id: 2, used_in_round: 2)
        allow(AssignmentQuestionnaire).to receive(:find).with('2').and_return(@assignment_questionnaire2)               
        @answer1 = double('Answer', id: 1, response_id: 1)
        allow(Answer).to receive(:find).with('1').and_return(@answer1)
        @answer2 = double('Answer', id: 2, question_id: 4, response_id: 5)
        allow(Answer).to receive(:find).with('2').and_return(@answer2)
    end
  
    describe '#get_latest_assignment' do
        context 'if find it successful' do
            it 'return latest assignment and round' do
                assignment = create(:assignment)
                questionnaire = create(:questionnaire)
                @assignment_questionnaire = create(:assignment_questionnaire, assignment_id: assignment.id, questionnaire_id: questionnaire.id, used_in_round: 1)
                expect(AssignmentQuestionnaire.get_latest_assignment(questionnaire.id)).to eq([assignment,@assignment_questionnaire.used_in_round])
            end
        end
    end
end
