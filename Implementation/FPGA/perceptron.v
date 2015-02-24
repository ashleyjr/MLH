module perceptron(
   input          clk,
   input          nRst,
   input          rx,    // Transmit this
   output         tx
);

   parameter   TIMED    = 50000;

   parameter   CHOICE         = 3'b000,
               ADDRESS        = 3'b001,
               WRITE_INPUT    = 3'b010,
               READ_INPUT     = 3'b011,
               WRITE_WEIGHT   = 3'b100,
               READ_WEIGHT    = 3'b101,
               OUTPUT         = 3'b110;


   wire           recieved;
   wire  [7:0]    data_rx;
   reg   [7:0]    address;
   reg            location;
   reg            rw;
   reg   [2:0]    state;
   reg   [31:0]   timeout;

   reg   [7:0]    input_data_in;
   reg            input_write;
   wire   [7:0]    input_data_out;
   reg            input_read;


   uart uart(
      .clk        (clk        ),
      .nRst       (nRst       ),
      .transmit   (     ),
      .data_tx    ( ),
      .rx         (rx    ),
      .busy_rx    ( ),
      .recieved   (recieved),
      .data_rx    (data_rx),
      .tx         (tx      )
   );


   registers inputs(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .data_in       (input_data_in),
      .read          (input_read),
      .write         (input_write),
      .data_out      (input_data_out),
      .valid         (   )
   );

   registers weights(
      .clk           (clk        ),
      .nRst          (nRst       ),
      .data_in       (  ),
      .read          (  ),
      .write         (     ),
      .data_out      (   ),
      .valid         (  )
   );





   always @(posedge clk or negedge nRst) begin
      if (!nRst) begin
         timeout        <= 0;
         state          <= CHOICE;

         input_write    <= 0;
         input_data_in  <= 0;
         input_read     <= 0;

      end else begin
         timeout <= timeout + 1;

         if(timeout == TIMED) begin
            state    <= CHOICE;
            timeout  <= 0;
         end else 

            case(state)
               CHOICE:        if(recieved) begin
                                 location <= data_rx[7];
                                 rw       <= data_rx[0];
                                 if(data_rx[6]) 
                                    state <= OUTPUT;
                                 else 
                                    state <= ADDRESS;
                              end


               ADDRESS:       if(recieved) begin
                                 address <= data_rx;
                                 if(location) begin
                                    if(rw) begin
                                       state          <= READ_INPUT;
                                       input_read     <= 1;
                                       input_data_in  <= data_rx;
                                    end else begin
                                       state          <= WRITE_INPUT;
                                       input_data_in  <= data_rx;
                                       input_write    <= 1;
                                    end
                                 end else begin
                                    if(rw) begin
                                       state <= READ_WEIGHT;
                                    end else begin
                                       state <= WRITE_WEIGHT;
                                    end
                                 end
                              end


               READ_INPUT:    if(recieved) begin
                                 input_read <= 0;
                                 state <= CHOICE;
                              end


               WRITE_INPUT:   if(recieved) begin
                                 input_data_in <= data_rx;
                                 input_write <= 0;
                                 state <= CHOICE;
                              end


               READ_WEIGHT:   state <= ADDRESS;
               WRITE_WEIGHT:  state <= ADDRESS;
               default: state <= ADDRESS;
            endcase

      end
   end


endmodule