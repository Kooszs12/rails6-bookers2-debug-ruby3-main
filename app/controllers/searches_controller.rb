class SearchesController < ApplicationController

  before_action :authenticate_user!

  def search
    #検索モデル
    @range =params[:range]
    #検索ワード
    @word =params[:word]

    if @range == "User"
      #インスタンス変数@usersにUserモデル内での検索結果を代入
      @users = User.looks(params[:search], params[:word])
    else
      #インスタンス変数@booksにBookモデル内での検索結果を代入
      @books = Book.looks(params[:search], params[:word])
    end
  end

end
