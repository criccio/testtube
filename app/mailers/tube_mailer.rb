class TubeMailer < ActionMailer::Base
  add_template_helper(PostsHelper)
  default from: 'someone@yourdomain.com'

  def new_post_mail(post, user)
    @post = post
    @user = user
    email_with_name = "#{user.fullname} <#{user.login}@yourdomain.com>"
    mail(to: email_with_name, subject: 'Test Tube: New Video Posted')
  end
end
