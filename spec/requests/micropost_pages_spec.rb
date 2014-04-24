require 'spec_helper'

describe "Micropost pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost pagination" do 
    before  do 
      50.times { FactoryGirl.create(:micropost, user: user, content: "This is for 10.5.2") }
      visit root_path
    end
    
    it "should list each micropost" do
      Micropost.paginate(page: 1).each do |m|
        expect(page).to have_content(m.content)
      end
    end
  end


  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end

     describe "as another user" do
      before do 
        another = FactoryGirl.create(:user)
        FactoryGirl.create(:micropost, user: another, content: "This is for 10.5.4")
        visit user_path(another)
      end
      
      it "should not be able to delete a micropost" do
        should_not have_link("delete")
      end
    end

  end


end