import subprocess
import json
import time

def main():
    while True:
        try:
            # Get the active keymap
            active_keymap = get_active_keymap()
            
            # Prepare the data to be passed to Waybar
            waybar_data = {
                "text": "hi!",
                "tooltip": f"Active Keymap: {active_keymap}"
            }
            
            # Convert the dictionary to a JSON string and print it
            print(json.dumps(waybar_data))
        except Exception as e:
            print(f"Error: {e}")
        
        # Wait for some time before running the command again (optional)
        time.sleep(5)  # For example, wait for 5 seconds before updating the keymap again

if __name__ == "__main__":
    main()