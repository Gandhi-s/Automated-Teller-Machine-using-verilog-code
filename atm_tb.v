module atm_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg [1:0] operation;
    reg [15:0] amount;
    reg [3:0] pin;
    reg [3:0] correct_pin;
    wire [15:0] balance;
    wire access_granted;
    wire transaction_successful;

    // Instantiate ATM module
    atm uut (
        .clk(clk),
        .reset(reset),
        .operation(operation),
        .amount(amount),
        .pin(pin),
        .correct_pin(correct_pin),
        .balance(balance),
        .access_granted(access_granted),
        .transaction_successful(transaction_successful)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Initial conditions
        reset = 1;
        pin = 4'b0000;
        correct_pin = 4'b1111;  // Set a test PIN
        #10 reset = 0;

        // Test case 1: Incorrect PIN attempt
        pin = 4'b1010;
        operation = 2'b00; // Check Balance
        #10;
        $display("Test 1 - Access Granted: %b, Balance: %d", access_granted, balance);

        // Test case 2: Correct PIN, Check Balance
        pin = correct_pin;
        operation = 2'b00; // Check Balance
        #10;
        $display("Test 2 - Access Granted: %b, Balance: %d", access_granted, balance);

        // Test case 3: Correct PIN, Deposit
        operation = 2'b01; // Deposit
        amount = 16'd500;
        #10;
        $display("Test 3 - Balance after deposit: %d, Transaction Successful: %b", balance, transaction_successful);

        // Test case 4: Correct PIN, Withdraw with sufficient balance
        operation = 2'b10; // Withdraw
        amount = 16'd300;
        #10;
        $display("Test 4 - Balance after withdrawal: %d, Transaction Successful: %b", balance, transaction_successful);

        // Test case 5: Correct PIN, Withdraw with insufficient balance
        operation = 2'b10; // Withdraw
        amount = 16'd2000;
        #10;
        $display("Test 5 - Balance after failed withdrawal: %d, Transaction Successful: %b", balance, transaction_successful);

        // End test
        $finish;
    end

endmodule

