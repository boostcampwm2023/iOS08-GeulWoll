import { PickType } from '@nestjs/swagger';
import { RecordModel } from '../entities/records.entity';

export class CreateExerciseLogDto extends PickType(RecordModel, [
  'workout',
  'workoutTime',
  'calorie',
  'distance',
  'avgBpm',
  'minBpm',
  'maxBpm',
]) {}
