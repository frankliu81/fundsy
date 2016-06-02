$(function() {
  var $form = $('#payment-form');

  var stripeResponseHandler = function(status, response) {
    //console.log("status is: " + status);
    //console.log(response);
    if (status === 200) {
      var token = response.id;
      // have a second form, to send the one-time use token to the server
      $("#stripe_token").val(token);
      $("#submit-form").submit();
    } else {
      $("#stripe-errors").html(response.error.message);
      $form.find(':submit').prop('disabled', false);
    }
  }

  $form.submit(function(event) {
    // Disable the submit button to prevent repeated clicks:
    // pseudo selector
    $form.find(':submit').prop('disabled', true);
// Request a token from Stripe:
    Stripe.card.createToken($form, stripeResponseHandler);
// Prevent the form from being submitted:
// stop propagation, event.stopPropagation; it prevents default, event.preventDefault
    return false;
  });
});
