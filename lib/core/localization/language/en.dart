const Map<String, String> en = {
  "app_name": "Wekala Core",

  // Auth
  'welcome_back': 'Welcome Back',
  'username': 'Username',
  'password': 'Password',
  'login': 'Login',
  'login_to_your_wekala_account': 'Login to your Wekala account',
  'remember_me': 'Remember Me',
  'logout': 'Logout',
  'logout_confirmation': 'Are you sure you want to logout?',

  // Common
  'loading': 'Loading...',
  'cancel': 'Cancel',
  'confirm': 'Confirm',
  'save': 'Save',
  'edit': 'Edit',
  'no_data': 'No Data',
  'see_all': 'See All',
  'please_select': 'Please Select',

  // Validation
  'username_required': 'Username is required',
  'password_required': 'Password is required',
  'password_invalid': 'Password is invalid',
  'customer_name_required': 'Customer name is required',
  'customer_phone_required': 'Customer phone number is required',
  'guests_required': 'Number of guests is required',
  'duration_minimum': 'Duration must be at least 15 minutes',

  // Dashboard
  'home': 'Home',
  'orders': 'Orders',
  'profile': 'Profile',

  // Dashboard - Welcome
  'good_morning': 'Good Morning',
  'good_afternoon': 'Good Afternoon',
  'good_evening': 'Good Evening',
  'ready_to_take_orders': 'Ready to take orders?',

  // Dashboard - New Order
  'start_new_order': 'Start New Order',
  'choose_service_type': 'Choose how you\'d like to serve',
  'service_type': 'Service Type',
  "no_services_available": "No services available",

  // Dashboard - Recent Orders
  'recent_orders': 'Recent Orders',
  'paid': 'Paid',
  'pending': 'Pending',
  'recent_transactions': 'Recent Transactions',
  "due": "Due",
  "partial": "Partial",

  // Dashboard - Summary
  'todays_summary': "Today's Summary",

  // Register
  'register_check': 'Checking Registration...',
  'cash_in_drawer': 'Cash in drawer',

  // Register - Open
  'enter_amount': 'Enter the amount',
  'select_location': 'Select the branch',
  'start_new_shift': 'Starting a new shift',

  // Register - Current Register
  'current_register': 'Current Register',
  'register_date': 'Register Date',
  'open': 'Open',

  // Register - Payment Methods
  'payment_method': 'Payment Method',
  'cash_payment': 'Cash Payment',
  'cheque_payment': 'Cheque Payment',
  'card_payment': 'Card Payment',
  'bank_transfer': 'Bank Transfer',
  'advance_payment': 'Advance Payment',
  'other_payments': 'Other Payments',

  // Register - Sales & Expenses
  'sell': 'Sales',
  'expense': 'Expenses',
  'total_sales': 'Total Sales',
  'total_refund': 'Total Refund',
  'total_expense': 'Total Expense',

  // Register - Total Calculation
  'total': 'Total',
  'opening': 'Opening',
  'sale': 'Sale',
  'refund': 'Refund',

  // Register - Cash Summary
  'cash_in_hand': 'Cash in hand',
  'total_cash': 'Total Cash',
  'total_card_slips': 'Total Card Slips',
  'total_cheques': 'Total Cheques',

  // Register - Details
  'sold_product_details': 'Sold Product Details',
  'sold_product_details_by_brand': 'Sold Product Details by Brand',
  'types_of_service_details': 'Types of Service Details',

  // Register - Product Details
  'sku': 'SKU',
  'product': 'Product',
  'brand': 'Brand',
  'service': 'Service',
  'quantity': 'Quantity',

  // Register - Closing
  'closing_note': 'Closing Note',
  'close_register': 'Close Register',
  'close_register_confirmation':
      'Are you sure you want to close this register?',
  "count_cash_before_closing":
      "Count the actual cash in the drawer before entering the amount below.",
  "sales_report_after_shift_closing":
      "The sales report will appear after the shift is closed.",
  "total_cash_required": "Total cash is required",
  "total_cheques_required": "Total cheques is required",
  "total_card_slips_required": "Total card slips are required",
  "register_details": "Register Details",
  "expected_cash": "Expected Cash",
  "actual_cash_counted": "Actual Cash Counted",
  "difference": "Difference",
  "balanced": "Balanced",
  "shortage": "Shortage",

  // User / Business
  'user': 'User',
  'email': 'Email',
  'business_location': 'Business Location',
  'branch': 'Branch',

  // Calculator
  'calculator': 'Calculator',

  // Sell POS
  "final": "Final",
  "draft": "Draft",
  "quantity_increased": "Increased by @count For quantity",
  "quantity_decreased": "Decreased by @count For quantity",

  // Tables
  'select_table': 'Select Table',
  'available': 'Available',
  'occupied': 'Occupied',
  'reserved': 'Reserved',
  'unavailable': 'Unavailable',
  'seats': 'Seats',
  'no_tables_available': 'No tables available',
  'no_table_selected': 'No table selected',

  // Tables - Actions
  'move_order': 'Move Order',
  'move_order_to_table': 'Move this order to @table?',
  'confirm_move': 'Move',
  'order_moved_successfully': 'Order moved to the new table successfully',
  'please_select_table_first': 'Please select a table first',

  // Guests / Items
  'item': 'Item',
  'items': 'Items',
  'items_count': '@count @item',
  'guest': 'Guest',
  'guests': 'Guests',
  'guests_count': '@count @guest',
  'number_of_guests': 'Number of Guests',

  // Customer
  'customer_name': 'Customer Name',
  'phone_number': 'Phone Number',

  // Reservation
  'reserve': 'Reserve',
  'reserve_table': 'Reserve Table',
  'date': 'Date',
  'time': 'Time',
  'reservation_duration': 'Reservation Duration (minutes)',
  'notes': 'Notes',
  'full_name': 'Full Name',
  'enter_reservation_notes': 'Enter reservation notes',

  // Reservation Actions
  'save_reservation': 'Save Reservation',
  'update_reservation': 'Update Reservation',
  'cancel_reservation': 'Cancel Reservation',
  'cancel_reservation_confirmation':
      'Are you sure you want to cancel this reservation?',
  'keep_reservation': 'Keep Reservation',
  'reservation_created_successfully': 'Reservation created successfully',
  'reservation_cancelled_successfully': 'Reservation cancelled successfully',
  'reservation_updated_successfully': 'Reservation updated successfully',

  // Order Actions
  'checked_in': 'Checked in',
  'start_order': 'Start Order',
  'view_add_items': 'View / Add Items',
  'send_to_kitchen': 'Send to Kitchen',
  'pay_and_close': 'Pay & Close',
  'switch_table': 'Switch Table',
  'open_new_order': 'Open New Order',
  'discount': 'Discount',
  'suspend': 'Suspend',
  'add_note': 'Add Note',
  'cancel_order': 'Cancel Order',
  'cancel_order_confirmation': 'Are you sure you want to cancel this order?',
  'cancel_order_description':
      'All selected products, customer, and table information will be cleared.',
  'yes_cancel': 'Yes, Cancel',
  'keep_order': 'Keep Order',

  // Discount
  'edit_discount': 'Edit Discount',
  'discount_type': 'Discount Type',
  'discount_type_required': 'Discount Type is required',
  'fixed': 'Fixed',
  'percentage': 'Percentage',
  'discount_amount': 'Discount Amount',
  'discount_amount_required': 'Discount Amount is required',
  'invalid_discount_amount': 'Please enter a valid discount amount.',
  'discount_amount_must_be_greater_than_zero':
      'Discount amount must be greater than zero.',
  'discount_percentage_max': 'Discount percentage cannot be greater than 100%.',

  // Customer & Subscription
  'customer': 'Customer',
  'select_customer': 'Select Customer',
  'walk_in_customer': 'Walk-in Customer',
  'subscribe': 'Subscribe',
  'subscribed': 'Subscribed',
  'not_subscribed': 'Not Subscribed',
  'search_customer': 'Search customer...',
  'search_by_name_phone_or_id': 'Search by name, phone, or customer ID',
  'unknown_customer': 'Unknown Customer',
  'no_customers_found_description':
      'Try a different name, phone number, or customer ID',
  'searching_customers': 'Searching customers...',
  'customer_selected': 'Customer selected',
  'no_customer_selected': 'No customer selected',
  'customer_due': 'Customer Due',

  // Order Empty State
  'start_adding_products': 'Start adding products',
  'choose_product_to_add_to_order':
      'Choose a product from the list to add it to the order',

  // Order Calculation
  'subtotal': 'Subtotal',
  'order_tax': 'Order Tax (+)',
  'shipping': 'Shipping (+)',
  'total_payable': 'Total Payable',
  'service_price': 'Service Price',

  // Order Checkout
  'pay': 'Pay',
  'payment': 'Payment',
  'available_balance': 'Available Balance',
  'sale_created_successfully': 'Sale created successfully',
  'amount': 'Amount',
  "edit_order_tax": "Edit order tax",
  "order_saved_successfully": "Order saved successfully",
  "order_held_successfully": "Order held successfully",
  "order_sent_to_kitchen_successfully": "Order sent to kitchen successfully",
  "payment_completed_successfully": "Payment completed successfully",

  // Checkout Payments
  "advance": "Advance Payment",
  "cash": "Cash",
  "card": "Card",
  "cheque": "Cheque",
  "other": "Other",
  "custom_payment": "Custom Payment",
  "amount_required": "Amount is required",
  "amount_must_be_greater_than_zero": "Amount must be greater than zero",
  "insufficient_payment_amount": "The paid amount is less than the amount due",
  "total_items": "Total Items",
  "change": "Change Due",
  "amount_due": "Amount Due",
  "enter_note": "Please enter a note",
  "clear": "Clear",
  "note_saved": "Note saved successfully",

  // Products
  'products': 'Products',
  'search_products': 'Search Products',
  'no_products_found': 'No products found',
  'no_products_added': 'No products added, add some products first',

  // Time
  'am': 'AM',
  'pm': 'PM',

  // Handel Errors
  "connection_error": "Connection Error",
  "please_check_your_internet_connection":
      "Please check your internet connection and try again.",
  "retry": "Retry",
  "no_internet_connection":
      "No internet connection. Please check your connection and try again.",
  "connection_timeout": "Connection timed out. Please try again.",
  "something_went_wrong": "Something went wrong. Please try again.",
  "server_error": "Server error. Please try again later.",
  "unauthorized": "Your session has expired. Please login again.",
  "bad_request": "Invalid request. Please try again.",
  "not_found": "The requested resource was not found.",
  "validation_error": "Please check the entered data.",
  "request_failed": "Request failed. Please try again.",
};
