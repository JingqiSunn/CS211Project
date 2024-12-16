import tkinter as tk
from tkinter import messagebox
import threading
import serial

# Define state mapping
STATE_MAP = {
    "00000001": "Power Off",
    "00000011": "Power Off",
    "00000010": "Power Off",
    "00000100": "Stand By",
    "00001001": "Menu",
    "00000111": "Level 1",
    "00000110": "Level 2",
    "00000101": "Level 3",
    "00001011": "Strong Stand By",
    "00001010": "Edit",
    "00001100": "Work Time"
}

class FPGAStateUI:
    def __init__(self, root):
        self.root = root
        self.root.title("FPGA State Panel")

        # Create a label to display the state
        self.state_label = tk.Label(
            root, text="Waiting for Signal...", font=("Helvetica", 18, "bold"), 
            bg="lightgray", fg="black", relief="sunken", anchor="center", width=30
        )
        self.state_label.pack(pady=10)

        # Create the alarm light (a red circle that will be shown below the state screen)
        self.alarm_light = tk.Label(
            root, text="ALARM LIGHT", font=("Helvetica", 16), fg="white", bg="gray", width=20, height=2
        )
        self.alarm_light.pack(pady=10)

        # Title for Current Time
        self.current_time_label = tk.Label(
            root, text="Current Time", font=("Helvetica", 16, "bold"),
            bg="lightgray", fg="black"
        )
        self.current_time_label.pack(pady=(10, 0))

        # Create the clock display label for Current Time
        self.clock_label = tk.Label(
            root, text="00:00:00", font=("Helvetica", 24, "bold"),
            bg="lightgray", fg="black", relief="sunken", anchor="center", width=30
        )   
        self.clock_label.pack(pady=(0, 10))

        # Title for Total Working Time
        self.total_working_time_label = tk.Label(
            root, text="Total Working Time", font=("Helvetica", 16, "bold"),
            bg="lightgray", fg="black"
        )
        self.total_working_time_label.pack(pady=(10, 0))

        # Create the clock display label for Total Working Time
        self.clock_label_2 = tk.Label(
            root, text="00:00:00", font=("Helvetica", 24, "bold"),
            bg="lightgray", fg="black", relief="sunken", anchor="center", width=30
        )   
        self.clock_label_2.pack(pady=(0, 10))

        # Buttons for starting and stopping the listener
        self.start_button = tk.Button(
            root, text="Start", command=self.start_listening, font=("Helvetica", 14), width=12
        )
        self.start_button.pack(pady=5)

        self.stop_button = tk.Button(
            root, text="Stop", command=self.stop_listening, font=("Helvetica", 14), width=12
        )
        self.stop_button.pack(pady=5)

        # Manual Self-Clean button
        self.clean_button = tk.Button(
            root, text="Manual Self Clean", command=self.manual_self_clean,
            font=("Helvetica", 16, "bold"), bg="blue", fg="white", width=20, height=2
        )
        self.clean_button.pack(pady=20)
        
        # Manual Self-Clean button
        self.Level_1_button = tk.Button(
            root, text="Level 1", command=self.level_1,
            font=("Helvetica", 16, "bold"), bg="blue", fg="white", width=20, height=2
        )
        self.Level_1_button.pack(pady=20)

        self.Level_2_button = tk.Button(
            root, text="Level 2", command=self.level_2,
            font=("Helvetica", 16, "bold"), bg="blue", fg="white", width=20, height=2
        )
        self.Level_2_button.pack(pady=20)

        self.Level_3_button = tk.Button(
            root, text="Level 3", command=self.level_3,
            font=("Helvetica", 16, "bold"), bg="blue", fg="white", width=20, height=2
        )
        self.Level_3_button.pack(pady=20)
        # Internal state
        self.serial_thread = None
        self.running = False
        self.current_state = None  # Track the current state to preserve on invalid signal
        self.alarm_on = False  # Flag to track the alarm state
        self.alarm_sequence = []  # To track the sequence of alarm signals
        self.alarm_sequence_2 = []  # To track the sequence of alarm reset signals
        
        # Clock values
        self.second_0 = None
        self.second_1 = None
        self.minute_0 = None
        self.minute_1 = None
        self.hour_0 = None
        self.hour_1 = None

        # Sequences for 3-in-a-row check
        self.second_0_sequence = []
        self.second_1_sequence = []
        self.minute_0_sequence = []
        self.minute_1_sequence = []
        self.hour_0_sequence = []
        self.hour_1_sequence = []
        
        # Second clock values
        self.second_0_2 = None
        self.second_1_2 = None
        self.minute_0_2 = None
        self.minute_1_2 = None
        self.hour_0_2 = None
        self.hour_1_2 = None

        # Sequences for the second clock's 3-in-a-row check
        self.second_0_2_sequence = []
        self.second_1_2_sequence = []
        self.minute_0_2_sequence = []
        self.minute_1_2_sequence = []
        self.hour_0_2_sequence = []
        self.hour_1_2_sequence = []
        # Sequence for state 3-in-a-row check
        self.state_sequence = []

    def start_listening(self):
        if self.running:
            return

        try:
            # Update with your FPGA's port and baudrate
            port = "/dev/ttyUSB1"
            baudrate = 9600
            self.ser = serial.Serial(port, baudrate, timeout=0)  # Set timeout to 0 for non-blocking mode
            self.running = True
            self.serial_thread = threading.Thread(target=self.listen_to_fpga, daemon=True)
            self.serial_thread.start()
        except serial.SerialException as e:
            messagebox.showerror("Error", f"Serial Error: {e}")

    def stop_listening(self):
        self.running = False
        if hasattr(self, "ser") and self.ser.is_open:
            self.ser.close()

    def listen_to_fpga(self):
        while self.running:
            if self.ser.in_waiting > 0:
                data = self.ser.read(self.ser.in_waiting)
                binary_data = [f'{byte:08b}' for byte in data]  # Convert bytes to binary strings

                # Update state and clock if any data is received
                if binary_data:
                    self.update_state(binary_data)
                    self.update_clock(binary_data)

    def update_state(self, binary_data):
        # Check for 3-in-a-row for the state
        for binary_signal in binary_data:
            state_name = STATE_MAP.get(binary_signal)
            if state_name:
                self.state_sequence.append(state_name)
                if len(self.state_sequence) > 3:
                    self.state_sequence.pop(0)  # Keep only the last 3 values
                
                if len(self.state_sequence) == 3 and len(set(self.state_sequence)) == 1:
                    # All three values are the same, update the state
                    self.current_state = state_name
                    self.state_sequence.clear()  # Clear the sequence after a valid update
                    break  # Exit the loop once a valid state update is made

            # Check for alarm signal logic
            if binary_signal.startswith("0001") and binary_signal != "00010000":
                # Record the non-"00010000" signal
                self.alarm_sequence.append(binary_signal)
                if len(self.alarm_sequence) >= 3:
                    # If there are 3 consecutive non-"00010000" signals, turn on the alarm
                    self.alarm_on = True
                    self.update_alarm_light()
                    self.alarm_sequence_2 = []
            elif binary_signal == "00010000":
                # Reset the alarm sequence on receiving "00010000"
                self.alarm_sequence_2.append(binary_signal)
                if len(self.alarm_sequence_2) >= 3:
                    # If there are 3 consecutive "00010000" signals, turn off the alarm
                    self.alarm_on = False
                    self.update_alarm_light()
                    self.alarm_sequence = []

        # Update the label with the current state or maintain the previous state
        if self.current_state:
            self.state_label.config(text=self.current_state)
        else:
            self.state_label.config(text="Invalid Signal")

    def update_alarm_light(self):
        # Update the alarm light's color based on the alarm state
        if self.alarm_on:
            self.alarm_light.config(bg="red")  # Alarm light ON (Red)
        else:
            self.alarm_light.config(bg="gray")  # Alarm light OFF (Gray)

    def update_clock(self, binary_data):
        # Update clock components for both clocks
        for binary_signal in binary_data:
            # First clock
            if binary_signal.startswith("1001"):  # second_0
                self.handle_clock_signal(binary_signal, "second_0")
            elif binary_signal.startswith("1000"):  # second_1
                self.handle_clock_signal(binary_signal, "second_1")
            elif binary_signal.startswith("1011"):  # minute_0
                self.handle_clock_signal(binary_signal, "minute_0")
            elif binary_signal.startswith("1010"):  # minute_1
                self.handle_clock_signal(binary_signal, "minute_1")
            elif binary_signal.startswith("1101"):  # hour_0
                self.handle_clock_signal(binary_signal, "hour_0")
            elif binary_signal.startswith("1100"):  # hour_1
                self.handle_clock_signal(binary_signal, "hour_1")

            # Second clock
            elif binary_signal.startswith("0011"):  # second_0_2
                self.handle_clock_signal(binary_signal, "second_0_2")
            elif binary_signal.startswith("0010"):  # second_1_2
                self.handle_clock_signal(binary_signal, "second_1_2")
            elif binary_signal.startswith("0101"):  # minute_0_2
                self.handle_clock_signal(binary_signal, "minute_0_2")
            elif binary_signal.startswith("0100"):  # minute_1_2
                self.handle_clock_signal(binary_signal, "minute_1_2")
            elif binary_signal.startswith("0111"):  # hour_0_2
                self.handle_clock_signal(binary_signal, "hour_0_2")
            elif binary_signal.startswith("0110"):  # hour_1_2
                self.handle_clock_signal(binary_signal, "hour_1_2")

        # Update the first clock display
        if all(v is not None for v in [self.second_0, self.second_1, self.minute_0, self.minute_1, self.hour_0, self.hour_1]):
            time_str = f"{self.hour_0}{self.hour_1}:{self.minute_0}{self.minute_1}:{self.second_0}{self.second_1}"
            self.clock_label.config(text=time_str)

        # Update the second clock display
        if all(v is not None for v in [self.second_0_2, self.second_1_2, self.minute_0_2, self.minute_1_2, self.hour_0_2, self.hour_1_2]):
            time_str_2 = f"{self.hour_0_2}{self.hour_1_2}:{self.minute_0_2}{self.minute_1_2}:{self.second_0_2}{self.second_1_2}"
            self.clock_label_2.config(text=time_str_2)

    def handle_clock_signal(self, signal, component):
        # Check if the component's sequence length reaches 3 (3-in-a-row checker)
        sequence = getattr(self, f"{component}_sequence")
        value = int(signal[-4:], 2)  # Get the last 4 bits and convert to integer
        
        sequence.append(value)
        if len(sequence) > 3:
            sequence.pop(0)  # Keep only the last 3 values

        if len(sequence) == 3 and len(set(sequence)) == 1:  # Check if all values are the same
            setattr(self, component, sequence[0])  # Update the component value
            sequence.clear()

    def manual_self_clean(self):
        try:
            if self.current_state != "Menu":
                messagebox.showwarning("Warning", "The button is only allowed in Menu state")
            elif hasattr(self, "ser") and self.ser.is_open:
                self.ser.write(b"\x00")  # Send 8-bit message 00000000
            else:
                messagebox.showwarning("Warning", "Serial port not open. Please start listening first.")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to send command: {e}")
    
    def level_1(self):
        try:
            if self.current_state != ("Level 2"):
                messagebox.showwarning("Warning", "Not allowed here")
            elif hasattr(self, "ser") and self.ser.is_open:
                self.ser.write(b"\xFF")  # Send 8-bit message 00000000
            else:
                messagebox.showwarning("Warning", "Serial port not open. Please start listening first.")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to send command: {e}")
    
    def level_2(self):
        try:
            if self.current_state != ("Level 1"):
                messagebox.showwarning("Warning", "Not allowed here")
            elif hasattr(self, "ser") and self.ser.is_open:
                self.ser.write(b"\x3F")  # Send 8-bit message 00000000
            else:
                messagebox.showwarning("Warning", "Serial port not open. Please start listening first.")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to send command: {e}")

    def level_3(self):
        try:
            if self.current_state != ("Stand By"):
                messagebox.showwarning("Warning", "Not allowed here")
            elif hasattr(self, "ser") and self.ser.is_open:
                self.ser.write(b"\x0F")  # Send 8-bit message 00000000
            else:
                messagebox.showwarning("Warning", "Serial port not open. Please start listening first.")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to send command: {e}")
if __name__ == "__main__":
    root = tk.Tk()
    app = FPGAStateUI(root)
    root.mainloop()


