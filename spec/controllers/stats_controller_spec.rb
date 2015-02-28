require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe StatsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Stat. As you add validations to Stat, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {category: :science, answer: 2.6, year: 2014, question: "___% of the world's total energy consumption comes from nuclear power.", source: "REN21", link: "http://www.ren21.net/Portals/0/documents/Resources/GSR/2014/GSR2014_KeyFindings_low%20res.pdf"}
  }

  let(:invalid_attributes) {
    {category: :blah, answer: 2.6, year: 2014, question: "___% of the world's total energy consumption comes from nuclear power.", source: "REN21", link: "http://www.ren21.net/Portals/0/documents/Resources/GSR/2014/GSR2014_KeyFindings_low%20res.pdf"}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # StatsController. Be sure to keep this updated too.
  let(:valid_session) { session }

  before(:each) do
    sign_in User.create!(email: 'tester@tester.com', password: 'somepass', password_confirmation: 'somepass')
  end

  describe "GET #index" do
    it "assigns all stats as @stats" do
      stat = Stat.create! valid_attributes
      get :index, {}
      expect(assigns(:stats).to_a).to eq([stat])
    end
    
    #TODO Creating 55 records is time-consuming, we can change this to accept a per_page,
    #     and test the default of 25 items elsewhere
    it "paginates stats as @stats" do
      list = TestObjects.stats!(55)
      
      # First page should have the latest 25 items
      get :index, {}
      expect(assigns(:stats).to_a).to eq(list[30..54].reverse)
      
      # Second page should have the next 25 items
      get :index, {'page' => '2'}
      expect(assigns(:stats).to_a).to eq(list[5..29].reverse)
      
      # Third page should have 5 remaining items
      get :index, {'page' => '3'}
      expect(assigns(:stats).to_a).to eq(list[0..4].reverse)
    end
    
    it 'assigns an empty array as @sqlite_file if there is no SqliteFile' do
      get :index, {}, valid_session
      expect(assigns(:sqlite_file)).to be_nil
    end
    
    it 'assigns search results as @stats' do
      list = TestObjects.stats!(1)
      get :index, {searchterm: 'question'}
      expect(assigns(:stats).to_a).to eq(list)
    end
  end

  describe "GET #show" do
    it "assigns the requested stat as @stat" do
      stat = Stat.create! valid_attributes
      get :show, {:id => stat.to_param}, valid_session
      expect(assigns(:stat)).to eq(stat)
    end
  end

  describe "GET #new" do
    it "assigns a new stat as @stat" do
      get :new, {}, valid_session
      expect(assigns(:stat)).to be_a_new(Stat)
    end
  end

  describe "GET #edit" do
    it "assigns the requested stat as @stat" do
      stat = Stat.create! valid_attributes
      get :edit, {:id => stat.to_param}, valid_session
      expect(assigns(:stat)).to eq(stat)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Stat" do
        expect {
          post :create, {:stat => valid_attributes}, valid_session
        }.to change(Stat, :count).by(1)
      end

      it "assigns a newly created stat as @stat" do
        post :create, {:stat => valid_attributes}, valid_session
        expect(assigns(:stat)).to be_a(Stat)
        expect(assigns(:stat)).to be_persisted
      end

      it "redirects to the created stat" do
        post :create, {:stat => valid_attributes}, valid_session
        expect(response).to redirect_to(Stat.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved stat as @stat" do
        post :create, {:stat => invalid_attributes}, valid_session
        expect(assigns(:stat)).to be_a Stat
        expect(assigns(:stat)).to be_new_record
      end

      it "re-renders the 'new' template" do
        post :create, {:stat => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {category: :society, answer: 1, year: 2015, question: "The world population is currently growing at ___% per year.", source: "US Census Bureau", link: "http://www.census.gov/population/international/data/worldpop/table_population.php"}
      }

      it "updates the requested stat" do
        stat = Stat.create! valid_attributes
        orig_stat = stat.as_json
        put :update, {:id => stat.to_param, :stat => new_attributes}, valid_session
        stat.reload
        expect(orig_stat).to_not eq(stat.as_json)
      end

      it "assigns the requested stat as @stat" do
        stat = Stat.create! valid_attributes
        put :update, {:id => stat.to_param, :stat => valid_attributes}, valid_session
        expect(assigns(:stat)).to eq(stat)
      end

      it "redirects to the stat" do
        stat = Stat.create! valid_attributes
        put :update, {:id => stat.to_param, :stat => valid_attributes}, valid_session
        expect(response).to redirect_to(stat)
      end
    end

    context "with invalid params" do
      it "assigns the stat as @stat" do
        stat = Stat.create! valid_attributes
        put :update, {:id => stat.to_param, :stat => invalid_attributes}, valid_session
        expect(assigns(:stat)).to eq(stat)
      end

      it "re-renders the 'edit' template" do
        stat = Stat.create! valid_attributes
        put :update, {:id => stat.to_param, :stat => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested stat" do
      stat = Stat.create! valid_attributes
      expect {
        delete :destroy, {:id => stat.to_param}, valid_session
      }.to change(Stat, :count).by(-1)
    end

    it "redirects to the stats list" do
      stat = Stat.create! valid_attributes
      delete :destroy, {:id => stat.to_param}, valid_session
      expect(response).to redirect_to(stats_url)
    end
  end
  
  describe 'POST #sync' do
    it 'creates a sqlite file in the DB that contains all existing stats' do
      list = TestObjects.stats!(2)
      expect {
        post :sync, {}, valid_session
      }.to change(SqliteFile, :count).by(1)
      
      begin
        dbfile = Tempfile.new('test-sqlite')

        IO.binwrite(dbfile, SqliteFile.first.file.data)
        db = Sequel.connect("sqlite://#{dbfile.path}")
        sqlite_stats = db[:stats].all

        expect(sqlite_stats.count).to eq 2      
        sqlite_stats.each_with_index do |x, i|
          expect(x[:category]).to eq(list[i].category_cd)
          expect(x[:question]).to eq(list[i].question)
          expect(x[:answer]).to eq(list[i].answer)
          expect(x[:source]).to eq(list[i].source)
          expect(x[:year]).to eq(list[i].year)
          expect(x[:link]).to eq(list[i].link)
        end
      ensure
        db.disconnect
        dbfile.unlink
      end
    end
    
    it 'redirects to the stats page' do
      post :sync, {}, valid_session
      expect(response).to redirect_to(stats_url)
    end
    
    it 'stores a maximum of 5 SqliteFiles in the DB' do
      TestObjects.stats!(2)
      files = []
      5.times do
        SqliteFile.create!(file: BSON::Binary.new('test', :generic))
      end
      post :sync, {}, valid_session
      
      expect(SqliteFile.count).to eq 5
    end
  end
  
  describe 'GET #sync' do
    it 'redirects to the stats page if SqliteFile does not exist' do
      get :sync, {}, valid_session
      expect(response).to redirect_to(stats_url)
    end
  end

end
