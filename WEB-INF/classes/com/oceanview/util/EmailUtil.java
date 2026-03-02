package com.oceanview.util;

import java.util.Properties;
import javax.mail.Session;
import javax.mail.Message;
import javax.mail.Transport;
import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import javax.mail.MessagingException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

/**
 * EmailUtil - Utility class for sending emails using JavaMail API.
 */
public class EmailUtil {

    // SMTP Configuration - Update these with actual server details
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String SMTP_USER = "chathumik2004@gmail.com"; // User email
    private static final String SMTP_PASS = "ujhu uxkj iddr aeoq"; // App password or password

    /**
     * Sends a bill email to the guest.
     * 
     * @param toEmail   Guest's email address
     * @param guestName Guest's name
     * @param billText  Formatted bill details
     * @return true if sent successfully, false otherwise
     */
    public static boolean sendBillEmail(String toEmail, String guestName, String billText) {
        if (toEmail == null || toEmail.isEmpty()) {
            return false;
        }

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", SMTP_HOST);
        props.put("mail.smtp.port", SMTP_PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SMTP_USER, SMTP_PASS);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SMTP_USER));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Your Bill - Ocean View Resort");

            String content = "<h2>Hello " + guestName + ",</h2>"
                    + "<p>Thank you for staying at Ocean View Resort. Please find your bill details below:</p>"
                    + "<div style='border: 1px solid #ddd; padding: 20px; background-color: #f9f9f9;'>"
                    + billText.replace("\n", "<br>")
                    + "</div>"
                    + "<p>We hope to see you again soon!</p>"
                    + "<br><p>Best regards,<br><b>Ocean View Resort Team</b></p>";

            message.setContent(content, "text/html");

            Transport.send(message);
            System.out.println("Email sent successfully to: " + toEmail);
            return true;

        } catch (MessagingException e) {
            System.err.println("Error sending email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
