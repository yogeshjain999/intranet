require 'spec_helper'

describe AttachmentsController do
  before(:each) do
    @admin = FactoryGirl.create(:user, role: 'Admin')
    sign_in @admin
  end

  context "GET index" do

    it "should find all company documents" do
      d1 = FactoryGirl.create(:attachment, document_type: 'company')
      d1 = FactoryGirl.create(:attachment, name: 'doc', document_type: 'company')
      get :index
      docs = Attachment.company_documents
      expect(assigns(:company_docs)).to eq(docs)
    end

    it "should have new attachment" do
      get :index
      assigns(:attachment).new_record? == true
    end

    it "should respond with success" do
      get :index
      should respond_with(:success)
      should render_template(:index)
    end
  end
  
  context "POST create" do
    it "should create new attachment record" do
      post :create, attachment: {name: 'photo', document_type: "company"}
      expect(flash[:notice]).to eq("Document saved successfully") 
      should redirect_to attachments_path
    end
  end

  context "GET edit" do
    before(:each) do
      @attachment = FactoryGirl.create(:attachment, document_type: 'company') 
      get :edit, id: @attachment.id, format: "js"
    end

    it "should have valid record for edit" do
      expect(assigns(:attachment)).not_to be(nil)
      expect(assigns(:attachment)).to eq(@attachment)
    end

    it "should respond with success" do
      should respond_with(:success)
      should render_template("edit")
    end
  end

  context "PATCH update" do
    it "should update attachment record" do
      attachment = FactoryGirl.create(:attachment, name: "Photo", document_type: 'company') 
      patch :update, { attachment: { name: "Form" }, id: attachment.id}
      attachment.reload
      expect(:attachment).not_to eq(nil)
      expect(assigns(:attachment)).to eq(attachment)
      expect(attachment.name).to eq("Form")
      expect(flash[:notice]).to eq("Document updated successfully") 
      should redirect_to attachments_path
    end
  end

  context "DELETE destroy" do
    it "should delete attachment record" do
      attachment = FactoryGirl.create(:attachment, name: "Photo", document_type: 'company') 
      delete :destroy, { id: attachment.id }
      expect(flash[:notice]).to eq("Document deleted Succesfully") 
      should redirect_to attachments_path
    end
  end

  context "GET download_document" do
    it "should download document" do
    end
  end
end
