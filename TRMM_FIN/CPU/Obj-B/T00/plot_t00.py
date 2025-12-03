import matplotlib.pyplot as plt
import csv
import collections
import sys

# Data structure: data[perm] = list of (size, gflops)
data = collections.defaultdict(list)

try:
    with open('results.csv', 'r') as f:
        reader = csv.reader(f)
        # Skip header
        header = next(reader, None)
        
        for row in reader:
            if not row: continue
            
            # The row might look like: ['ijp', '32', '32', ' 1.54'] depending on output
            # We safely grab the first item (perm), second item (size), and LAST item (gflops)
            try:
                perm = row[0]
                size = int(row[1])
                
                # The GFLOPS is typically the last value in the row
                # We strip whitespace just in case
                gflops = float(row[-1].strip())
                
                data[perm].append((size, gflops))
            except (ValueError, IndexError) as e:
                # Debug print to help identify why data is missing
                # If your CSV contains "result", this will trigger.
                print(f"Skipping bad line: {row} -> Error: {e}")
                continue
            
    if not data:
        print("\nERROR: No valid data found in results.csv.")
        print("This usually means the benchmark binary printed headers but no numbers.")
        print("Check your Makefile arguments (ensure min < max).")
        sys.exit(1)

    plt.figure(figsize=(10, 6))
    
    # Define colors for consistency
    colors = {'ijp': 'r', 'jip': 'g', 'ipj': 'b', 'pij': 'c', 'jpi': 'm', 'pji': 'y'}
    
    for perm, points in data.items():
        points.sort() # ensure sorted by size
        sizes = [p[0] for p in points]
        perfs = [p[1] for p in points]
        plt.plot(sizes, perfs, marker='o', label=perm, color=colors.get(perm, 'k'))

    plt.title('Objective B, T00: Loop Order Performance')
    plt.xlabel('Matrix Size (N)')
    plt.ylabel('Performance (GFLOPS)')
    plt.legend()
    plt.grid(True)
    
    output_file = 'loop_comparison.png'
    plt.savefig(output_file)
    print(f"Plot saved as {output_file}")

except FileNotFoundError:
    print("Error: results.csv not found. Run 'make run_bench' first.")
except Exception as e:
    print(f"An error occurred: {e}")