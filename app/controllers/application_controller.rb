class ApplicationController < ActionController::Base
protect_from_forgery with: :exception
# セッション用ヘルパーの読み込み
include SessionsHelper


def hello
	render html: "hello world!"
end

end
