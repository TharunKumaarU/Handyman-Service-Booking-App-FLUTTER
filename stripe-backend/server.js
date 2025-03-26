// server.js
require('dotenv').config(); // Load environment variables from .env
const express = require('express');
const stripe = require('stripe')(process.env.STRIPE_SECRET_KEY); // Use your secret key from the .env file
const app = express();

// Log the Stripe secret key for debugging purposes.
// (Note: Remove or comment this out in production to avoid exposing sensitive information.)
console.log('Stripe Secret Key:', process.env.STRIPE_SECRET_KEY);

// Middleware to parse JSON requests
app.use(express.json());

// Endpoint to create a PaymentIntent
app.post('/create-payment-intent', async (req, res) => {
  const { amount, currency } = req.body;
  try {
    // Create a PaymentIntent with the specified amount and currency,
    // and explicitly allow card payments.
    const paymentIntent = await stripe.paymentIntents.create({
      amount: amount, // e.g., AED in fils (if 1 AED = 100 fils)
      currency: currency, // e.g., 'aed'
      payment_method_types: ['card'],
    });

    // Send the client_secret to the client
    res.json({ client_secret: paymentIntent.client_secret });
  } catch (error) {
    console.error('Error creating PaymentIntent:', error);
    res.status(500).json({ error: error.message });
  }
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
