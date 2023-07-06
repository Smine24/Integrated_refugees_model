# Integrated_refugees_model
This model depicts the process of refugee integration.

## WHAT IS IT?

The integration of refugees refers to the process by which forcibly displaced individuals, due to conflicts, human rights violations, or other difficult circumstances, adapt and join the society of the host country. Integration involves creating a sense of belonging and mutual acceptance between refugees and members of the host society, as well as the active participation of refugees in all aspects of social, economic, cultural, and political life in the community.

This model depicts the process of refugee integration.

## HOW IT WORKS?

The simulation begins by creating a population of migrants and a local population. Each agent is assigned an ethnicity: "local" (represented by the color blue) or "migrant" (represented by the color green).

Each agent is characterized by their "language," "religious," and "culture," which can be 0 or 1. Migrants with a "factor_migration" less than 0.5 are considered agents who do not have the ability to migrate, while those with a "factor_migration" equal to or greater than 0.5 are considered agents who have the ability to migrate. Additionally, migrants with a "learning_language" equal to or greater than 0.5 have learned the language of the host country more rapidly, increasing their chances of integration into the host community.

The variable "integration_acceptance" determines whether a migrant can immigrate by summing the values of "language," "culture," and "religious." If the sum is greater than or equal to 2, the migrants can move towards the host community. These migrants retain their green color and create links with other agents who have a "factor_migration" greater than or equal to 0.5. On the other hand, red agents are migrants who have immigrated but do not meet the integration criteria (they can be considered as rejected).

In summary, the simulation creates a population of migrants and locals, assigns attributes to each agent such as language, culture, religious beliefs, and migration factors. It evaluates the integration acceptance of migrants based on their attributes and determines their ability to move towards the host community. The simulation aims to explore how these factors impact the integration of migrants into the local community.


## HOW TO USE IT

- number_local [0,1000]: number local agents
- number_migrant [0,1000] number migrant agents
- speed_intake [0, 100]: percentage of migrant agents moving together to host country

## THINGS TO NOTICE

In our simulation, we have four histograms:

1.  "level_language_migrant" represents the level of language learning among migrants. The red color is assigned to migrants with a high level of language learning, while the blue color represents migrants with a low level of language learning.

2.  "Persons non-migrated X Persons migrated" represents the number of migrants who have successfully migrated versus those who have not migrated.

3.  "Integrated X Non-integrated" represents the number of migrants who have successfully integrated into the host community versus those who have not integrated

4.   'migrant-intake' represents percentage of migrant agents moving together to host country

## REFERENCES

model by Smiralda Milfort based on MigrAgent of Rocco Paolillo.

Rocco Paolillo, Wander Jager (2018, November 28). “MigrAgent” (Version 1.2.0). CoMSES Computational Model Library. Retrieved from: https://doi.org/10.25937/b454-rq57
