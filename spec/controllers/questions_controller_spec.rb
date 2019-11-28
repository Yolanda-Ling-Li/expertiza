describe QuestionsController do
  let(:questionnaire) do
    build(id: 1, name: 'questionnaire', ta_id: 8, course_id: 1, private: false, min_question_score: 0, max_question_score: 5, type: 'ReviewQuestionnaire')
  end
  let(:questionnaire) { build(:questionnaire) }
  let(:quiz_questionnaire) { build(:questionnaire, type: 'QuizQuestionnaire') }
  let(:review_questionnaire) { build(:questionnaire, type: 'ReviewQuestionnaire') }
  let(:question) { build(:question, id: 1) }
  let(:admin) { build(:admin) }
  let(:instructor) { build(:instructor, id: 6) }
  let(:instructor2) { build(:instructor, id: 66) }
  let(:ta) { build(:teaching_assistant, id: 8) }
  before(:each) do
    allow(Questionnaire).to receive(:find).with('1').and_return(questionnaire)
    stub_current_user(instructor, instructor.role.name, instructor.role)
  end

  describe '#destroy' do
    context 'success' do
      it 'deletes the question' do
	      params = {id: 1}
        post :destroy,params
        expect(flash[:success]).to eq("You have successfully deleted the question!")
      end
    end
  end

  describe '#update' do
    before(:each) do
      @questionnaire1 = double('Questionnaire', id: 1)
      allow(Questionnaire).to receive(:find).with('1').and_return(@questionnaire1)
      @params = {id: 1,
                 questionnaire: {name: 'test questionnaire',
                                 instructor_id: 6,
                                 private: 0,
                                 min_question_score: 0,
                                 max_question_score: 5,
                                 type: 'ReviewQuestionnaire',
                                 display_type: 'Review',
                                 instructor_loc: ''}}
      @params_with_question = {id: 1,
                               questionnaire: {name: 'test questionnaire',
                                               instructor_id: 6,
                                               private: 0,
                                               min_question_score: 0,
                                               max_question_score: 5,
                                               type: 'ReviewQuestionnaire',
                                               display_type: 'Review',
                                               instructor_loc: ''},
                               question: {'1' => {seq: 66.0,
                                                  txt: 'WOW',
                                                  weight: 10,
                                                  size: '50,3',
                                                  max_label: 'Strong agree',
                                                  min_label: 'Not agree'}}}
    end

    context 'when params[:add_new_questions] is not nil and instructor add it in period' do
      it 'redirects to questionnaire#add_new_questions' do
        params = {id: 1,
                  add_new_questions: true,
                  new_question: {total_num: 2,
                                 type: 'TextArea'}}
        post :update, params
        expect(flash[:success]).to eq('You have successfully added a new question. The existing reviews for the questionnaire have been deleted!')
        expect(response).to redirect_to action: 'add_new_questions', id: params[:id], question: params[:new_question]
      end
    end

    context 'when params[:add_new_questions] is not nil and instructor add it out of period' do
      it 'redirects to questionnaire#add_new_questions' do
        params = {id: 1,
                  add_new_questions: true,
                  new_question: {total_num: 2,
                                 type: 'TextArea'}}
        post :update, params
        expect(flash[:success]).to eq('You have successfully added a new question.')
        expect(response).to redirect_to action: 'add_new_questions', id: params[:id], question: params[:new_question]
      end
    end
  end

end
