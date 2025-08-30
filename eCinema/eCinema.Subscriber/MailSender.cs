using MailKit.Net.Smtp;
using MimeKit;
using MailKit.Security;

namespace eCinema.Subscriber
{
    public static class MailSender
    {
        public static void SendEmail(EmailDTO email)
        {
            Console.WriteLine("Sending email to: " + email.EmailTo);
            try
            {
                var emailMessage = new MimeMessage();
                emailMessage.From.Add(new MailboxAddress("eCinema", "noreply@ecinema.com"));
                emailMessage.To.Add(MailboxAddress.Parse(email.EmailTo));
                
                string htmlBody;
                
                if (email.Type == Model.Messages.EmailType.StaffCredentials)
                {
                    emailMessage.Subject = email.Subject;
                    htmlBody = $@"
                        <div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;'>
                            <h2 style='color: #1a237e;'>Hi {email.ReceiverName},</h2>
                            
                            <p style='font-size: 16px;'>Welcome to the eCinema Staff Team!</p>
                            
                            <p style='font-size: 16px; line-height: 1.6;'>
                                Your staff account has been created. Here are your login credentials for the mobile app:
                            </p>
                            
                            <div style='background-color: #f5f5f5; padding: 15px; border-radius: 5px; margin: 20px 0;'>
                                {email.Message}
                            </div>
                            
                            <p style='font-size: 16px; line-height: 1.6; color: #d32f2f;'>
                                Please change your password after your first login for security purposes.
                            </p>
                            
                            <p style='margin-top: 30px;'>
                                Best regards,<br>
                                <strong>The eCinema Team</strong>
                            </p>
                        </div>";
                }
                else
                {
                    emailMessage.Subject = "Welcome to eCinema – Your Front Row Seat Awaits!";
                    htmlBody = $@"
                        <div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px;'>
                            <h2 style='color: #1a237e;'>Hi {email.ReceiverName},</h2>
                            
                            <p style='font-size: 16px;'>Welcome to eCinema! 🍿</p>
                            
                            <p style='font-size: 16px; line-height: 1.6;'>
                                You're officially part of the club where movies, snacks, and epic cinema moments come together. 
                                Your account is ready, your popcorn is popping, and the big screen is calling your name.
                            </p>
                            
                            <p style='font-size: 16px; line-height: 1.6;'>
                                Go ahead, explore our screenings, make your first reservation, and may your favorite seat always be available!
                            </p>
                            
                            <p style='font-size: 16px;'>Lights, camera, action! 🎬</p>
                            
                            <p style='margin-top: 30px;'>
                                Cheers,<br>
                                <strong>The eCinema Team</strong>
                            </p>
                        </div>";
                }
                emailMessage.Body = new TextPart("html") { Text = htmlBody };

                using (var client = new SmtpClient())
                {
                    var smtpHost = Environment.GetEnvironmentVariable("SMTP_HOST") ?? "smtp.gmail.com";
                    var smtpPort = int.Parse(Environment.GetEnvironmentVariable("SMTP_PORT") ?? "587");
                    var emailUsername = Environment.GetEnvironmentVariable("EMAIL_USERNAME");
                    var emailPassword = Environment.GetEnvironmentVariable("EMAIL_PASSWORD");

                    client.Connect(smtpHost, smtpPort, MailKit.Security.SecureSocketOptions.StartTls);
                    client.Authenticate(emailUsername, emailPassword);
                    client.Send(emailMessage);
                    client.Disconnect(true);
                    Console.WriteLine($"Email sent to {email.EmailTo}");
                }
            }
            catch (SmtpCommandException ex)
            {
                Console.WriteLine($"SMTP Error sending email to {email.EmailTo}: {ex.Message} (Status: {ex.StatusCode})");
            }
            catch (SmtpProtocolException ex)
            {
                Console.WriteLine($"SMTP Protocol Error sending email to {email.EmailTo}: {ex.Message}");
            }
            catch (AuthenticationException ex)
            {
                Console.WriteLine($"Authentication Error sending email to {email.EmailTo}: {ex.Message}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Unexpected error sending email to {email.EmailTo}: {ex.Message}");
                Console.WriteLine($"Stack trace: {ex.StackTrace}");
            }
        }
    }
}
