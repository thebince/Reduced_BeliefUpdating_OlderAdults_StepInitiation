function sequence = constrainedRandomSequence(num_elements, odds_ratio, max_zeros, max_ones)

% Generate constrained random sequence of 0 and 1 with fixed odds ratio and
% bounded number of repeated 0s and 1s.

% generate sequence with the prescribed number of ones and zeros
sequence = zeros(num_elements,1);
sequence(1:round(odds_ratio*num_elements)) = 1;

% permute order
sequence = sequence(randperm(num_elements));

% determine maximum number of consecutive ones and zeros
num_ones = max(rcumsum(sequence));
num_zeros = max(rcumsum(~sequence));

% continue to permute until both are below the set boundaries
while num_zeros>max_zeros || num_ones>max_ones
    sequence = sequence(randperm(num_elements));

    num_ones = max(rcumsum(sequence));
    num_zeros = max(rcumsum(~sequence));
end

