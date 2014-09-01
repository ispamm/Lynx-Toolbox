function set_semisupervised_partitioning( p )
% set_semisupervised_partitioning - Change the partitioning strategy for
% semi-supervised training

s = Simulation.getInstance();
s.ss_partition = p;

end

