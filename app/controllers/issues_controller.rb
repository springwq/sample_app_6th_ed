class IssuesController < ApplicationController
  before_action :get_issue, except: :index

  def index 
    @issues = Issue.all.order("updated_at desc")
  end

  def new
    @issue = Issue.new
  end

  def create
    # form_tag: 
    # @issue = Issue.new({title: params[:title], content: params[:content]})

    @issue = Issue.new(issue_params)
    Rails.logger.info("==============#{params[:issue]}")
    Rails.logger.info("==============#{params[:issue][:title_111]}")
    if @issue.save
      Rails.logger.info("==============#{issue_params[:title_111]}")
      respond_to do |format|
        format.html { redirect_to issues_path }
        format.js
      end
    else 
      redirect_to issues_path
    end
  end

  def edit;end

  def update
    if @issue.update(issue_params)
     
      respond_to do |format|
        format.html { redirect_to issues_path }
        format.js
      end
    else 
      redirect_to issues_path
    end
  end

  def destroy 
    @issue.destroy 
    redirect_to issues_path
  end

  private 

  def get_issue
    @issue = Issue.find_by(id: params[:id])
  end

  def issue_params
    params.require(:issue).permit(:title, :content)
  end
end