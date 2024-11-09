module atm (
    input clk,
    input reset,
    input [1:0] operation,  // 00: Check Balance, 01: Deposit, 10: Withdraw
    input [15:0] amount,    // Amount for deposit/withdrawal
    input [3:0] pin,        // User PIN input
    input [3:0] correct_pin, // Correct PIN for verification
    output reg [15:0] balance, // Balance output
    output reg access_granted, // 1 if correct PIN entered
    output reg transaction_successful // 1 if transaction completed successfully
);

    // States for ATM operations
    parameter CHECK_BALANCE = 2'b00;
    parameter DEPOSIT       = 2'b01;
    parameter WITHDRAW      = 2'b10;

    // Initial balance
    initial begin
        balance = 16'd1000; // Example initial balance
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            balance <= 16'd1000;       // Reset balance to initial
            access_granted <= 0;
            transaction_successful <= 0;
        end else begin
            // PIN verification
            if (pin == correct_pin) begin
                access_granted <= 1;
                transaction_successful <= 0;

                case (operation)
                    CHECK_BALANCE: begin
                        transaction_successful <= 1;
                    end

                    DEPOSIT: begin
                        balance <= balance + amount;
                        transaction_successful <= 1;
                    end

                    WITHDRAW: begin
                        if (amount <= balance) begin
                            balance <= balance - amount;
                            transaction_successful <= 1;
                        end else begin
                            transaction_successful <= 0; // Insufficient funds
                        end
                    end

                    default: begin
                        transaction_successful <= 0;
                    end
                endcase

            end else begin
                access_granted <= 0;
                transaction_successful <= 0;
            end
        end
    end
endmodule

