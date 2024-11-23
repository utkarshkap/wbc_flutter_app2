part of 'review_bloc.dart';

@immutable
abstract class ReviewState {}

class ReviewInitial extends ReviewState {}

class InsuranceReviewInitial extends ReviewState {}

class InsuranceReviewDataAdding extends ReviewState {}

class InsuranceReviewDataAdded extends ReviewState {
  InsuranceReviewDataAdded();
}

class InsuranceReviewFailed extends ReviewState {}

class MFReviewInitial extends ReviewState {}

class MFReviewDataAdding extends ReviewState {}

class MFReviewDataAdded extends ReviewState {
  final Response data;

  MFReviewDataAdded(this.data);
}

class MFReviewFailed extends ReviewState {}

class UploadMFReviewInitial extends ReviewState {}

class UploadMFReviewDataAdding extends ReviewState {}

class UploadReviewDataAdded extends ReviewState {}

class UploadMFReviewFailed extends ReviewState {}

class UploadRealEstateDataInitial extends ReviewState {}

class UploadRealEstateDataAdding extends ReviewState {}

class UploadRealEstateDataAdded extends ReviewState {}

class UploadRealEstateDataFailed extends ReviewState {}

class UploadStockReviewInitial extends ReviewState {}

class UploadStockReviewDataAdding extends ReviewState {}

class UploadStockDataAdded extends ReviewState {}

class UploadStockReviewFailed extends ReviewState {}

class LoanReviewInitial extends ReviewState {}

class LoanReviewDataAdding extends ReviewState {}

class LoanReviewDataAdded extends ReviewState {
  final Response data;

  LoanReviewDataAdded(this.data);
}

class LoanReviewFailed extends ReviewState {}

class ReviewHistoryInitial extends ReviewState {}

class ReviewHistoryLoadedState extends ReviewState {
  final ReviewHistory reviewHistory;

  ReviewHistoryLoadedState(this.reviewHistory);
}

class ReviewHistoryErrorState extends ReviewState {
  final String error;

  ReviewHistoryErrorState(this.error);
}
