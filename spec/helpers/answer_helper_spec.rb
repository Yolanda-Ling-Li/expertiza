describe AnswerHelper do
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

  describe '#delete_existing_responses' do
    it 'renders questionnaires#view page' do
      # allow(Answer).to receive(:Where).with(@answer2.question_id).and_return(@answer2.response_id)
      # expect(AnswerHelper).to receive(:delete_answers).with(@answer2.response_id)
      # AnswerHelper.delete_existing_responses([@answer2.response_id])
    end
  end

  describe '#review_mailer' do
    it 'calls method in Mailer to send emails' do
      @email = "aaa@ncsu.edu"
      @answers = "answers"
      @name = "name"
      @assignment_name = "assignment_name"
      allow(Mailer).to receive(:notify_review_rubric_change).with(
        to: @email,
        subject: 'Expertiza Notification: The review rubric has been changed, please re-attempt the review',
        body: {
            name: @name,
            assignment_name: @assignment_name,
            answers: @answers
        }).and_return(@mail)
      allow(@mail).to receive(:deliver_now)
      expect(Mailer).to receive(:notify_review_rubric_change).once
      AnswerHelper.review_mailer(@email, @answers, @name, @assignment_name)
    end
  end

  describe '#delete_answers' do
    it 'renders questionnaires#view page' do
      allow(Answer).to receive(:Where).with(@answer1.response_id).and_return(@answer1)
      @result = AnswerHelper.delete_answers(@answer1.response_id)
      expect(@result).to eql([])
    end
  end

  describe '#in_active_period' do
    it 'returns true when the current time is in active period' do
      allow(AssignmentQuestionnaire).to receive(:get_latest_assignment).with(1).and_return([@assignment1, 1])
      allow(@assignment1).to receive(:find_review_period).with(1).and_return([[@duedate1], [@duedate2]])
      expect(AnswerHelper.in_active_period(1)).to eql(true)
    end
    it 'returns false when the current time is not in active period' do
      allow(AssignmentQuestionnaire).to receive(:get_latest_assignment).with(2).and_return([@assignment1, 2])
      allow(@assignment1).to receive(:find_review_period).with(2).and_return([[@duedate3], [@duedate4]])
      expect(AnswerHelper.in_active_period(2)).to eql(false)
    end
  end

  describe '#has_questionnaire_in_period' do
    it 'returns true when the current time in any active period' do
      allow(AssignmentQuestionnaire).to receive(:get_rounds).with(1).and_return([@assignment1, 1])
      allow(@assignment1).to receive(:find_review_period).with(1).and_return([[@duedate1], [@duedate2]])
      expect(AnswerHelper.has_questionnaire_in_period(1)).to eql(true)
    end
    it 'returns false when the current time is not in any active period' do
      allow(AssignmentQuestionnaire).to receive(:get_rounds).with(2).and_return([@assignment1, 2])
      allow(@assignment1).to receive(:find_review_period).with(2).and_return([[@duedate3], [@duedate4]])
      expect(AnswerHelper.has_questionnaire_in_period(2)).to eql(false)
    end
  end
end